using Godot;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using aigui.addons.dotnet;
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
using Perception;

public partial class Bridge : Node
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}

	private Dictionary<Node, List<Node>> _hierarchy;

	private Node CreateAiNode()
	{
		var gridSpace = GetNode("GridSpace");
		var connections = gridSpace.GetChildren()
			.Where(x => x.IsClass("NodeConnection")).ToList();
		_hierarchy = GetHierarchy(connections);
		
		var actionManager = new ActionManager();
		var tree = new BehaviorTree();
		var bb = new BlackboardWrapper(new Node());
		
		var rootNode = GetRoot(_hierarchy);

		tree.Root = BuildBlock(rootNode, tree, bb);
		
		return new GodotAiComponent(new AiComponent(actionManager, tree, bb, new List<Sensor>(CreateSensors(bb, gridSpace))));
	}

	private IEnumerable<SensorWrapper> CreateSensors(Blackboard bb, Node gridSpace)
	{
		return gridSpace.GetChildren()
			.Where(x => x.IsClass("Sensor")) // TODO: change "Sensor" to appropriate classname because sensor stores logic, not ref to it
			.Select(LoadLinkedGdNode)
			.Select(x => new SensorWrapper(bb, x));
	}

	private List<Node> GetTreeChildren(Node node)
	{
		return _hierarchy[node];
	}

	private Dictionary<Node, List<Node>> GetHierarchy(List<Node> connections)
	{
		var res = new Dictionary<Node, List<Node>>();
		foreach (var connection in connections)
		{
			var parent = GetNode((NodePath)connection.Get("parent_base"));
			var child = GetNode((NodePath)connection.Get("child_base"));

			if (res.TryGetValue(parent, out var re))
			{
				re.Add(child);
			}
			else
			{
				res[parent] = new List<Node> { child };
			}
		}

		return res;
	}

	private Node GetRoot(Dictionary<Node, List<Node>> hierarchy)
	{
		var nonRoots = new HashSet<Node>();
		foreach (var value in hierarchy.Values)
		{
			nonRoots.UnionWith(value);
		}

		return hierarchy.Keys.First(x => !nonRoots.Contains(x));
	}

	private TreeTask DecorateTreeTask(List<Node> decorators, TreeTask treeTask, Blackboard bb)
	{
		if (decorators.Count == 0) return treeTask;

		var node = decorators[0];
		return new Decorator(new DecoratorWrapper(bb, LoadLinkedGdNode(node)),
			DecorateTreeTask(decorators.Skip(1).ToList(), treeTask, bb));
	}
	
	private TreeTask BuildBlock(Node node, BehaviorTree tree, Blackboard bb)
	{
		var decorators = node.GetChildren().Where(x => x.IsClass("Decorator")).ToList();
		
		if (node.IsClass("BaseLeaf"))
		{
			return DecorateTreeTask(decorators, new Leaf(new LeafLogicWrapper(node)), bb);
		}
		
		var treeTasks = GetTreeChildren(node).Select(x => BuildBlock(x, tree, bb)).ToList();

		return DecorateTreeTask(decorators, node.GetClass() switch
		{
			"Selector" => new Selector(treeTasks),
			"Sequence" => new Sequence(treeTasks, tree),
			_ => throw new InvalidEnumArgumentException("Tree can only consist of tree nodes, but gotten class " +
			                                            node.GetClass())
		}, bb);
	}

	private Node LoadLinkedGdNode(Node node)
	{
		var path = (string)node.Get("leaf_logic");
		// TODO: separate logic nodes and nodes, which store paths to logic everywhere here
		var script = (GDScript)GD.Load(path);
		return (Node) script.New();
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
