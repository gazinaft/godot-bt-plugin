using System.Threading.Tasks;
using DecisionMaking.BehaviorTree.Task.Leaf;
using Godot;


namespace aigui.addons.dotnet.Wrappers;

[Tool]
public class LeafLogicWrapper: LeafLogic
{
    private readonly Node _node;
    
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

    public override bool IsComplete
    {
        get => (bool)_node.Get("_is_complete");
        protected set => _node.Set("_is_complete", value);
    }
}