using System.Threading.Tasks;
using DecisionMaking.BehaviorTree.Task.Leaf;
using Godot;


namespace aigui.addons.dotnet.Wrappers;

public class LeafLogicWrapper: LeafLogic
{
    private Node _node;
    
    public LeafLogicWrapper(Node node)
    {
        _node = node;
    }
    
    public override void Start()
    {
        _node._Ready();
    }

    public override Task Update(float delta)
    {
        _node._Process(delta);
        return Task.CompletedTask;
    }
}