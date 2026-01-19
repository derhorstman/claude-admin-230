#!/bin/bash
# Build Windows 11 Unattended ISO
# Usage: build-windows-iso.sh <source_iso> <target_iso> [username] [password] [hostname]

set -e

SOURCE_ISO="$1"
TARGET_ISO="$2"
USERNAME="${3:-dieterhorst}"
PASSWORD="${4:-Fantasy+}"
HOSTNAME="${5:-*}"

DASBIEST="192.168.42.16"
REMOTE_PATH="D:/ISOs"
BASE_DIR="/var/tmp/win-iso"
WORK_DIR="${BASE_DIR}/work"
MOUNT_DIR="${BASE_DIR}/mount"
ISO_DIR="${BASE_DIR}"

echo "=== Windows ISO Builder ==="
echo "Source: $SOURCE_ISO"
echo "Target: $TARGET_ISO"
echo "User: $USERNAME"

# Cleanup
sudo rm -rf "$BASE_DIR"
mkdir -p "$WORK_DIR" "$MOUNT_DIR" "$ISO_DIR"
chmod 777 "$BASE_DIR" "$ISO_DIR"

# Copy ISO from DASBIEST (use sudo -u to preserve SSH keys)
echo "Kopiere ISO von DASBIEST..."
sudo -u dieterhorst scp "dieterhorst@${DASBIEST}:${REMOTE_PATH}/${SOURCE_ISO}" "${ISO_DIR}/${SOURCE_ISO}"

# Mount ISO
echo "Mounte ISO..."
sudo mount -o loop "${ISO_DIR}/${SOURCE_ISO}" "$MOUNT_DIR"

# Copy contents
echo "Kopiere Inhalte..."
cp -r "$MOUNT_DIR"/* "$WORK_DIR"/

# Unmount
sudo umount "$MOUNT_DIR"

# Make writable
chmod -R u+w "$WORK_DIR"

# Create autounattend.xml
echo "Erstelle autounattend.xml..."
cat > "$WORK_DIR/autounattend.xml" << XMLEOF
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <SetupUILanguage><UILanguage>de-DE</UILanguage></SetupUILanguage>
            <InputLocale>de-DE</InputLocale>
            <SystemLocale>de-DE</SystemLocale>
            <UILanguage>de-DE</UILanguage>
            <UserLocale>de-DE</UserLocale>
        </component>
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Path>reg add HKLM\SYSTEM\Setup\LabConfig /v BypassTPMCheck /t REG_DWORD /d 1 /f</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <Path>reg add HKLM\SYSTEM\Setup\LabConfig /v BypassSecureBootCheck /t REG_DWORD /d 1 /f</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>3</Order>
                    <Path>reg add HKLM\SYSTEM\Setup\LabConfig /v BypassRAMCheck /t REG_DWORD /d 1 /f</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
            <DiskConfiguration>
                <Disk><DiskID>0</DiskID><WillWipeDisk>true</WillWipeDisk>
                    <CreatePartitions>
                        <CreatePartition><Order>1</Order><Type>EFI</Type><Size>300</Size></CreatePartition>
                        <CreatePartition><Order>2</Order><Type>MSR</Type><Size>128</Size></CreatePartition>
                        <CreatePartition><Order>3</Order><Type>Primary</Type><Extend>true</Extend></CreatePartition>
                    </CreatePartitions>
                    <ModifyPartitions>
                        <ModifyPartition><Order>1</Order><PartitionID>1</PartitionID><Format>FAT32</Format><Label>System</Label></ModifyPartition>
                        <ModifyPartition><Order>2</Order><PartitionID>2</PartitionID></ModifyPartition>
                        <ModifyPartition><Order>3</Order><PartitionID>3</PartitionID><Format>NTFS</Format><Label>Windows</Label><Letter>C</Letter></ModifyPartition>
                    </ModifyPartitions>
                </Disk>
            </DiskConfiguration>
            <ImageInstall>
                <OSImage>
                    <InstallFrom>
                        <MetaData wcm:action="add">
                            <Key>/IMAGE/NAME</Key>
                            <Value>Windows 11 Pro</Value>
                        </MetaData>
                    </InstallFrom>
                    <InstallTo>
                        <DiskID>0</DiskID>
                        <PartitionID>3</PartitionID>
                    </InstallTo>
                </OSImage>
            </ImageInstall>
            <UserData>
                <ProductKey>
                    <Key>W269N-WFGWX-YVC9B-4J6C9-T83GX</Key>
                    <WillShowUI>OnError</WillShowUI>
                </ProductKey>
                <AcceptEula>true</AcceptEula>
            </UserData>
        </component>
    </settings>
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <ComputerName>${HOSTNAME}</ComputerName>
            <TimeZone>W. Europe Standard Time</TimeZone>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Work</NetworkLocation>
                <ProtectYourPC>3</ProtectYourPC>
            </OOBE>
            <UserAccounts><LocalAccounts><LocalAccount>
                <Password><Value>${PASSWORD}</Value><PlainText>true</PlainText></Password>
                <Description>Admin</Description><DisplayName>${USERNAME}</DisplayName>
                <Group>Administrators</Group><Name>${USERNAME}</Name>
            </LocalAccount></LocalAccounts></UserAccounts>
            <AutoLogon>
                <Password><Value>${PASSWORD}</Value><PlainText>true</PlainText></Password>
                <Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${USERNAME}</Username>
            </AutoLogon>
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Description>Set Password</Description>
                    <CommandLine>cmd /c net user ${USERNAME} "${PASSWORD}"</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <Description>Install OpenSSH</Description>
                    <CommandLine>powershell -ExecutionPolicy Bypass -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>3</Order>
                    <Description>Configure SSH Port 2222</Description>
                    <CommandLine>powershell -ExecutionPolicy Bypass -Command "\$c=Get-Content 'C:\ProgramData\ssh\sshd_config'; \$c=\$c -replace '#Port 22','Port 2222'; \$c|Set-Content 'C:\ProgramData\ssh\sshd_config'"</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>4</Order>
                    <Description>Start SSH</Description>
                    <CommandLine>powershell -ExecutionPolicy Bypass -Command "Start-Service sshd; Set-Service -Name sshd -StartupType Automatic"</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>5</Order>
                    <Description>Firewall SSH 2222</Description>
                    <CommandLine>powershell -ExecutionPolicy Bypass -Command "New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 2222"</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>6</Order>
                    <Description>Install Node.js</Description>
                    <CommandLine>powershell -ExecutionPolicy Bypass -Command "\$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi' -OutFile 'C:\node.msi'; Start-Process msiexec.exe -Wait -ArgumentList '/i','C:\node.msi','/quiet'; Remove-Item 'C:\node.msi'"</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>7</Order>
                    <Description>Install Git</Description>
                    <CommandLine>powershell -ExecutionPolicy Bypass -Command "\$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe' -OutFile 'C:\git.exe'; Start-Process 'C:\git.exe' -Wait -ArgumentList '/VERYSILENT','/NORESTART'; Remove-Item 'C:\git.exe'"</CommandLine>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <Order>8</Order>
                    <Description>Install Claude Code</Description>
                    <CommandLine>powershell -ExecutionPolicy Bypass -Command "\$env:Path=[System.Environment]::GetEnvironmentVariable('Path','Machine'); npm install -g @anthropic-ai/claude-code"</CommandLine>
                </SynchronousCommand>
            </FirstLogonCommands>
        </component>
    </settings>
</unattend>
XMLEOF

# Use noprompt boot image if available (no "Press any key" prompt)
EFI_BOOT="efi/microsoft/boot/efisys.bin"
if [ -f "$WORK_DIR/efi/microsoft/boot/efisys_noprompt.bin" ]; then
    # Copy noprompt version over the regular one
    cp "$WORK_DIR/efi/microsoft/boot/efisys_noprompt.bin" "$WORK_DIR/efi/microsoft/boot/efisys.bin"
    echo "Verwende efisys_noprompt.bin (kein 'Press any key' Prompt)"
fi

# Build new ISO with xorriso
echo "Baue neue ISO..."
xorriso -as mkisofs \
    -o "${ISO_DIR}/${TARGET_ISO}" \
    -iso-level 3 \
    -J -joliet-long \
    -rational-rock \
    -b boot/etfsboot.com \
    -no-emul-boot \
    -boot-load-size 8 \
    -eltorito-alt-boot \
    -e efi/microsoft/boot/efisys.bin \
    -no-emul-boot \
    "$WORK_DIR"

# Copy back to DASBIEST
echo "Kopiere ISO zurück zu DASBIEST..."
sudo -u dieterhorst scp "${ISO_DIR}/${TARGET_ISO}" "dieterhorst@${DASBIEST}:${REMOTE_PATH}/${TARGET_ISO}"

# Cleanup
echo "Aufräumen..."
sudo rm -rf "$BASE_DIR"

echo "=== FERTIG: ${TARGET_ISO} ==="
