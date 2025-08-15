using Vintagestory.API.Client;
using Vintagestory.API.Common;
using Vintagestory.API.Config;
using Vintagestory.API.Server;

namespace StarlessSkies
{
    public class StarlessSkiesModSystem : ModSystem
    {
        public override void StartServerSide(ICoreServerAPI api)
        {
            api.WorldManager.SetSunBrightness(0);
            float[] zeroSunLevels = new float[32];
            api.WorldManager.SetSunLightLevels(zeroSunLevels);
        }
    }
}
