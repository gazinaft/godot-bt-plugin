using CoreEntities.Blackboard;
using DecisionMaking.BehaviorTree.Task.Decorator;
using Godot;

namespace aigui.addons.dotnet.Wrappers;

public class DecoratorWrapper: DecoratorLogic
{
    private Node _node; 
    public DecoratorWrapper(Blackboard blackboard, Node node) : base(blackboard)
    {
        _node = node;
    }

    public override bool CanRun()
    {
        return (bool)_node.Call("can_pass");
    }
}