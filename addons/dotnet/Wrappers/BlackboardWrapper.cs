using CoreEntities.Blackboard;
using Godot;


namespace aigui.addons.dotnet.Wrappers;

[Tool]
public class BlackboardWrapper: Blackboard
{
    
    public Node _node;

    public BlackboardWrapper(Node node)
    {
        _node = node;
    }
    
    
}