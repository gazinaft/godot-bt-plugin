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

	private Node CreateAiNode()
	{
		var gridSpace = GetNode("GridSpace");
		
		var actionManager = new ActionManager();
		var tree = new BehaviorTree();
		var bb = new BlackboardWrapper(new Node());

		var rootNode = GetRoot();

		tree.Root = BuildBlock(rootNode, tree, bb);
		
		return new GodotAiComponent(new AiComponent(actionManager, tree, bb, new List<Sensor>(CreateSensors(bb, gridSpace))));
	}

	private IEnumerable<SensorWrapper> CreateSensors(Blackboard bb, Node gridSpace)
	{
		return gridSpace.GetChildren()
			.Where(x => x.IsClass("Sensor")) // TODO: change "Sensor" to appropriate classname because sensor stores logic, not ref to it
			.Select(x => x.Get("leaf_logic"))
			.Select(x => new SensorWrapper(bb, LoadGdNode((string)x)));
	}

	private List<Node> GetTreeChildren(Node node)
	{
		return new List<Node>();
	}

	private Node GetRoot()
	{
		return null;
	}
	
	private TreeTask BuildBlock(Node node, BehaviorTree tree, Blackboard bb)
	{
		if (node.IsClass("BaseLeaf"))
		{
			return new Leaf(new LeafLogicWrapper(node));
		}
		
		var treeTasks = GetTreeChildren(node).Select(x => BuildBlock(x, tree, bb)).ToList();

		return node.GetClass() switch
		{
			"Decorator" => new Decorator(new DecoratorWrapper(bb, node), treeTasks[0]),
			"Selector" => new Selector(treeTasks),
			"Sequence" => new Sequence(treeTasks, tree),
			_ => throw new InvalidEnumArgumentException("Tree can only consist of tree nodes, but gotten class " +
			                                            node.GetClass())
		};
	}

	private Node LoadGdNode(string path)
	{
		// TODO: separate logic nodes and nodes, which store paths to logic everywhere here
		var script = (GDScript)GD.Load(path);
		return (Node) script.New();
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}