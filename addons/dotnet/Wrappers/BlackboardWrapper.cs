using CoreEntities.Blackboard;
using Godot;


namespace aigui.addons.dotnet.Wrappers;

public class BlackboardWrapper: Blackboard
{
    
    private Node _node;

    public BlackboardWrapper(Node node)
    {
        _node = node;
    }
    
    
}