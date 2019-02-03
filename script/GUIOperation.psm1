filter Move-WindowRect{
    Param
    (
        [String]$Title,
        [Int]$X = 0,
        [Int]$Y = 0,
        [Int]$Width = 400,
        [Int]$Height = 300
    )

    Get-Process | ?{$_.MainWindowTitle -eq $Title} | %{
        [GUIOperation]::MoveWindow($_.MainWindowHandle, $X, $Y, $Width, $Height, $true)
    } | Out-Null
}

filter Get-WindowRect (){
    Get-Process | ?{$_.MainWindowTitle -ne ""} | %{
        $rc = New-Object RECT
        [GUIOperation]::GetWindowRect($_.MainWindowHandle, [ref]$rc) | Out-Null
        ConvertTo-Window $_.Name $_.MainWindowTitle $rc
    }
}
filter ConvertTo-Window ($name, $title, $rc){
    $win = New-Object WINDOW

    $win.AppName = $name
    $win.Title = $title
    $win.X = $rc.Left
    $win.Y = $rc.Top
    $win.Width = $rc.Right - $rc.Left
    $win.Height = $rc.Bottom - $rc.Top

    $win
}

$source = @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public struct RECT
{
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}

public struct WINDOW
{
    public string AppName;
    public string Title;
    public int X;
    public int Y;
    public int Width;
    public int Height;
}

public class GUIOperation {
    // マウス関連のWin32API
    [DllImport("User32.dll")]
    static extern bool GetCursorPos(out POINT lppoint);
    [StructLayout(LayoutKind.Sequential)]
    struct POINT
    {
        public int X { get; set; }
        public int Y { get; set; }
    }

    [DllImport("user32.dll")]
    extern static uint SendInput(
        uint       nInputs,   // INPUT 構造体の数(イベント数)
        INPUT[]    pInputs,   // INPUT 構造体
        int        cbSize     // INPUT 構造体のサイズ
    );
    [StructLayout(LayoutKind.Sequential)]
    struct INPUT
    { 
        public int type; // 0 = INPUT_MOUSE(デフォルト), 1 = INPUT_KEYBOARD
        public MOUSEINPUT mi;
    }
    [StructLayout(LayoutKind.Sequential)]
    struct MOUSEINPUT
    {
        public int    dx ;
        public int    dy ;
        public int    mouseData ;  // amount of wheel movement
        public int    dwFlags;
        public int    time;        // time stamp for the event
        public IntPtr dwExtraInfo;
    }
    const int MOUSEEVENTF_MOVED      = 0x0001 ;
    const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;  // 左ボタン Down
    const int MOUSEEVENTF_LEFTUP     = 0x0004 ;  // 左ボタン Up
    const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;  // 右ボタン Down
    const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;  // 右ボタン Up
    const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;  // 中ボタン Down
    const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;  // 中ボタン Up
    const int MOUSEEVENTF_WHEEL      = 0x0080 ;
    const int MOUSEEVENTF_XDOWN      = 0x0100 ;
    const int MOUSEEVENTF_XUP        = 0x0200 ;
    const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

    const int screen_length = 0x10000 ;  // for MOUSEEVENTF_ABSOLUTE (この値は固定)

    // Window関連のWin32API
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    // WindowActivate関連のWin32API
    [System.Runtime.InteropServices.DllImport(
    "user32.dll", CharSet = System.Runtime.InteropServices.CharSet.Auto)]
    static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [System.Runtime.InteropServices.DllImport("user32.dll")]
    static extern bool SetForegroundWindow(IntPtr hWnd);

    // PowerShellから呼び出されるメソッド
    // 指定した座標を左クリックするメソッド
    public static void LeftClick(int x, int y) {
        INPUT[] input = new INPUT[3];
        // MOUSEEVENTF_ABSOLUTEの場合、画面サイズは 65535 で考えるので
        // 自分の解像度に合わせて修正すること(この場合 1024*768)
        // マウスに対する一連の動作の配列。1回目は移動。2回目は左ボタン押下。3回目は左ボタン開放。
        input[0].mi.dx = x * (65535 / 1024);
        input[0].mi.dy = y * (65535 / 768);
        input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
        input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
        input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
        SendInput(3, input, Marshal.SizeOf(input[0]));
    }

    // マウスの座標を取得するメソッド
    public static string GetCursorPosition(){
        POINT pt = new POINT();
        GetCursorPos(out pt);
        return pt.X + " " + pt.Y;
    }

    // 指定したWindowをアクティブにするメソッド
    public static bool ActivateWindow(string winTitle) {
        IntPtr hWnd = FindWindow(null, winTitle);
        if (hWnd != IntPtr.Zero) {
            SetForegroundWindow(hWnd);
            return true;
        }
        else {
            return false;
        }
    }

    // 指定したキーを送信するメソッド
    public static void SendKey(string key) {
        SendKeys.SendWait(key);
    }
}
"@
Add-Type -Language CSharp -TypeDefinition $source -ReferencedAssemblies System.Windows.Forms