# Cargar las ensamblados de WPF
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Importar el archivo XAML
[xml]$xaml = Get-Content -Path ".\view\index.xaml"

# Crear un objeto de ventana
$window = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $xaml))

# Cargar la imagen de fondo
$backgroundImageBrush = $window.FindName("BackgroundImageBrush")
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$imagePath = Join-Path -Path $scriptPath -ChildPath "img\backgroud.png"
$imageSource = [System.Windows.Media.Imaging.BitmapImage]::new($imagePath)
$backgroundImageBrush.ImageSource = $imageSource

# Obtener elementos de la ventana
$submitButton = $window.FindName("SubmitButton")
$folderInput = $window.FindName("FolderInput")
$versionInput = $window.FindName("VersionInput")
$RAMInput = $window.FindName("RAMInput")

# Función para manejar el evento de clic del botón
$submitButton.Add_Click({
    $folderName = $folderInput.Text
    $version = $versionInput.Text
    $RAM = $RAMInput.Text

    if (-not ([string]::IsNullOrEmpty($folderName)) -and -not ([string]::IsNullOrEmpty($version)) -and -not ([string]::IsNullOrEmpty($RAM))) {
        & ".\script\crear.ps1" -Folder $folderName -ServerVersion $version -ServerRAM $RAM
        $window.Close()
    } else {
        [System.Windows.MessageBox]::Show("Por favor, complete todos los campos.")
    }
})

# Mostrar la ventana
$window.ShowDialog() | Out-Null
