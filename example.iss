; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "MY NEUTRALINOJS APPNAME"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "rince"
#define MyAppURL "https://github.com/rince1984"
#define MyAppExeName "MyNeuApp-win_x64.exe" //compiled exe name in the dist folder (created through neu build)
#define sourceDirectory "C:\APPS\NEUTRALINOJS\MyNeuApp" //main folder of the app
#define sourceDistDirectory "C:\APPS\NEUTRALINOJS\MyNeuApp\dist\MyNeuApp" //dist folder of the app
#define installerOutDirectory "C:\APPS\NEUTRALINOJS\Installer\MyNeuApp" //installer destination folder
#define MyDateTimeString GetDateTimeString('yyyymmdd', '', '') //just an example, only needed for a script (see [Code] section)

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A1B23CD4-EFGH-567I-866C-614F601D1X23}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile={#sourceDirectory}\resources\License.txt //license text shown in a setup step
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir={#installerOutDirectory} //destination for the compiled installer (created setup file)
OutputBaseFilename=Setup_{#MyAppVersion} //installer/setup file name
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl" //of course you can use another language
//Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Dirs]
Name: "{app}\.storage"; Permissions: everyone-full
Name: "{app}\7z"; Permissions: everyone-full

//include files from source dirs
[Files]
Source: "{#sourceDistDirectory}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#sourceDistDirectory}\resources.neu"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#sourceDistDirectory}\WebView2Loader.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#installerOutDirectory}\.storage\global.neustorage"; DestDir: "{app}\.storage\"; Flags: ignoreversion recursesubdirs createallsubdirs; Permissions: everyone-full
Source: "{#sourceDirectory}\7z\*"; DestDir: "{app}\7z\"; Flags: ignoreversion recursesubdirs createallsubdirs; Permissions: everyone-full
Source: "{#installerOutDirectory}\demo.lic"; DestDir: "{app}\key\"; AfterInstall: DemoLicense('{#MyDateTimeString}'); Flags: ignoreversion recursesubdirs createallsubdirs; Permissions: everyone-full //include sample demo.lic file and call procedure after (see procedure in [Code] section)
; NOTE: Don't use "Flags: ignoreversion" on any shared system files


[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"

[Code]
//run CheckNetIsolation from commandline while setup:
procedure CurStepChanged(CurStep: TSetupStep);
var
  resultCode: Integer;
begin
  ShellExec('', 'CheckNetIsolation.exe', 'LoopbackExempt -a -n="Microsoft.Win32WebViewHost_cw5n1h2txyewy"','', SW_SHOW, ewWaitUntilTerminated, resultCode);
end;

//write variable infos to demo.lic file after installation:
procedure DemoLicense(dateString:String);
var
  newDateVar: Integer;
begin
  newDateVar := StrToInt(dateString); //convert string to integer
  newDateVar := newDateVar + 2; //calculation..
  dateString := IntToStr(newDateVar); //convert integer to string
    SaveStringToFile(ExpandConstant('{app}\key\demo.lic'), dateString, False); //write string to demo.lic file (without appending) - https://jrsoftware.org/ishelp/index.php?topic=isxfunc_savestringtofile
end;


