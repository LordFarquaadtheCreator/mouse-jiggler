using System;
using System.Runtime.InteropServices;

namespace mouseJiggler
{
    class jiggle
    {
        [DllImport("user32.dll")]
        private static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

        private const int MOUSEEVENTF_MOVE = 0x0001;
        private static int[] MovementArray = { 0x0002, 0x0004, 0x0008, 0x0010 };

        static void Main(string[] args)
        {
            Console.CancelKeyPress += new ConsoleCancelEventHandler(CancelEvent);
            
            while (true)
            {
                // sleep for one second
                var rand = new Random();
                int direction1 = rand.Next(0, 3);
                int direction2 = rand.Next(0, 3);

                mouse_event(MOUSEEVENTF_MOVE, MovementArray[direction1], MovementArray[direction2], 0, 0);
            }
        }

        protected static void CancelEvent(object sender, ConsoleCancelEventArgs args)
        {
            Environment.Exit(0);
        }
    }
}
