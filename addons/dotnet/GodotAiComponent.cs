using Direction;
using Godot;

namespace aigui.addons.dotnet;

public class GodotAiComponent : Node
{
    private AiComponent _ai;

    public GodotAiComponent(AiComponent ai)
    {
        _ai = ai;
    }

    public override void _Process(double delta)
    {
        _ai.Update((float)delta);
    }
    
}