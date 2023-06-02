using CoreEntities.Blackboard;
using Godot;
using Godot.Collections;


namespace aigui.addons.dotnet.Wrappers;

[Tool]
public class BlackboardWrapper: Blackboard
{
    public Node _node;

    public BlackboardWrapper(Node node)
    {
        _node = node;
    }

    public override void Update(float delta)
    {
        var dic = (Dictionary)_node.Get("entries");
        foreach ( var k in dic.Keys)
        {
            Set((string)k, dic[k]);
        }
        
        base.Update(delta);
    }
}