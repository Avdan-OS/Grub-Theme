# This script will install the github theme in your GNU/Linux distro

# The script will copy the 'src' directory, to boot/grub/themes
sudo mkdir -p /boot/grub/themes
echo "Creating themes directory under /boot/grub/..."
sudo cp ../src -r /boot/grub/themes/avdanos-grub-theme
echo "Copying the theme to themes directory..."

# Now the script will modify the /etc/default/grub file
sudo cp grub -r /etc/default/grub
echo "Modifying the /etc/default/grub file"

sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "Applying changes..."

echo "Now you can reboot your pc!"
