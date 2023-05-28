using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using aigui.addons.dotnet.Wrappers;
using CoreEntities.Actions;
using CoreEntities.Blackboard;
using DecisionMaking.BehaviorTree;
using DecisionMaking.BehaviorTree.Task;
using DecisionMaking.BehaviorTree.Task.Decorator;
using DecisionMaking.BehaviorTree.Task.Leaf;
using DecisionMaking.BehaviorTree.Task.Selector;
using DecisionMaking.BehaviorTree.Task.Sequence;
using Direction;
using Godot;
using Perception;

namespace aigui.addons.dotnet;

[Tool]
public partial class Bridge : Node
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}
	
	[Export] private NodePath _gridSpacePath;
	[Export] private bool _toBuild;
	[Export] private string _pathToBb;
	
	private Dictionary<Node, List<Node>> _hierarchy;

	private Node CreateAiNode()
	{
		var gridSpace = GetNode(_gridSpacePath);
		GD.Print(gridSpace);
		GD.Print(gridSpace.GetChildren().Select(x => x.Call("get_class")).Aggregate((x, y) => x + " " + y));
		var connections = gridSpace.GetChildren()
			.Where(x => (bool)x.Call("is_class", "NodeConnection")).ToList();
		foreach (var connection in connections)
		{
			GD.Print(connection);
		}
		
		_hierarchy = GetHierarchy(connections);
		
		var actionManager = new ActionManager();
		var tree = new BehaviorTree();

		var gdBb = GD.Load<GDScript>(_pathToBb);
		var bb = new BlackboardWrapper((Node)gdBb.New());
		
		var rootNode = GetRoot(_hierarchy);

		tree.Root = BuildBlock(rootNode, tree, bb);
		GD.Print(tree.ToString());
		
		return new GodotAiComponent(new AiComponent(actionManager, tree, bb, new List<Sensor>(CreateSensors(bb, gridSpace))));
	}

	private static IEnumerable<SensorWrapper> CreateSensors(BlackboardWrapper bb, Node gridSpace)
	{
		return gridSpace.GetChildren()
			.Where(x => (bool)x.Call("is_class", "Sensor"))
			.Select(x => LoadLinkedGdNode(x, bb._node))
			.Select(x => new SensorWrapper(bb, x));
	}

	private List<Node> GetTreeChildren(Node node)
	{
		return _hierarchy[node];
	}

	private static Dictionary<Node, List<Node>> GetHierarchy(List<Node> connections)
	{
		var temp = new Dictionary<Node, List<(float, Node)>>();
		foreach (var connection in connections)
		{
			var parent = connection.GetNode((NodePath)connection.Get("parent_base"));
			var child = connection.GetNode((NodePath)connection.Get("child_base"));

			GD.Print(parent);
			GD.Print(child);
			
			var childPosX = ((Control)connection.Get("child")).Position.X;
			GD.Print(childPosX);
			
			if (temp.TryGetValue(parent, out var re))
			{
				re.Add((childPosX, child));
			}
			else
			{
				temp[parent] = new List<(float, Node)> { (childPosX, child) };
			}
		}
		GD.Print("Constructing Hierarchy");

		var res = new Dictionary<Node, List<Node>>();
		foreach (var pair in temp)
		{
			res[pair.Key] = pair.Value.OrderBy(tuple => tuple.Item1).Select(x => x.Item2).ToList();
			GD.Print("Parent " + pair.Key);
			GD.Print("Children");
			foreach (var (x, node) in pair.Value)
			{
				GD.Print(node + " at x " + x);
			}
		}
		
		return res;
	}

	private static Node GetRoot(Dictionary<Node, List<Node>> hierarchy)
	{
		var nonRoots = new HashSet<Node>();
		foreach (var value in hierarchy.Values)
		{
			nonRoots.UnionWith(value);
		}
		
		var root = hierarchy.Keys.First(x => !nonRoots.Contains(x));
		GD.Print("The root is " + root.Name);
		
		return root;
	}

	private static TreeTask DecorateTreeTask(List<Node> decorators, TreeTask treeTask, BlackboardWrapper bb)
	{
		if (decorators.Count == 0) return treeTask;

		var node = decorators[0];
		GD.Print("Decorator is " + node);
		return new Decorator(new DecoratorWrapper(bb, LoadLinkedGdNode(node, bb._node)),
			DecorateTreeTask(decorators.Skip(1).ToList(), treeTask, bb));
	}
	
	private TreeTask BuildBlock(Node node, BehaviorTree tree, BlackboardWrapper bb)
	{
		var decorators = node.GetChildren().Where(x => (bool)x.Call("is_class","Decorator")).ToList();
		
		if ((bool)node.Call("is_class", "Leaf"))
		{
			return DecorateTreeTask(decorators, new Leaf(new LeafLogicWrapper(LoadLinkedGdNode(node))), bb);
		}
		
		var treeTasks = GetTreeChildren(node).Select(x => BuildBlock(x, tree, bb)).ToList();

		return DecorateTreeTask(decorators, (string)node.Call("get_class") switch
		{
			"Selector" => new Selector(treeTasks),
			"Sequence" => new Sequence(treeTasks, tree),
			_ => throw new InvalidEnumArgumentException("Tree can only consist of tree nodes, but gotten class " +
			                                            node.Call("get_class"))
		}, bb);
	}

	private static Node LoadLinkedGdNode(Node node, Node blackboard = null)
	{
		var path = (string)node.Get("leaf_logic");
		var script = (GDScript)GD.Load(path);
		if (blackboard == null)
		{
			return (Node) script.New();
		}

		return (Node)script.New(blackboard);
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (_toBuild)
		{
			GD.Print("Started construnction");
			GodotAiComponent ai = (GodotAiComponent)CreateAiNode();
			
			ai._Process(17);
		}

		_toBuild = false;
	}

}