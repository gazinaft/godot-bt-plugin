using CoreEntities.Blackboard;
using Perception;
using Godot;

namespace aigui.addons.dotnet.Wrappers;

public class SensorWrapper : Sensor
{

    private Node _node;
    public SensorWrapper(Blackboard blackboard, Node node) : base(blackboard)
    {
        _node = node;
    }

    public override void Sense(float delta)
    {
        _node._Process(delta);
    }
}