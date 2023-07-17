echo '== Setting up Dpkg options =='
export DEBIAN_FRONTEND=noninteractive
echo -e 'Dpkg::Options {\n  "--force-confnew";\n}' > ~/../usr/etc/apt/apt.conf.d/local

echo '== Removing invalid repositories =='
pkg remove -y game-repo
pkg remove -y science-repo

echo '== Updating repositories and upgrading packages =='
pkg update -y
pkg upgrade -y

echo '== Installing python, openssl, and nodejs =='
pkg install -y python openssl nodejs

echo '== Removing added Dpkg options =='
rm ~/../usr/etc/apt/apt.conf.d/local

echo '== Installing homebridge and homebridge-config-ui =='
npm install -g --unsafe-perm homebridge homebridge-config-ui-x

echo '== Creating default config =='
mkdir -p ~/.homebridge
echo -e '{
	"bridge": {
		"name": "Homebridge BA3D",
		"username": "0E:F1:D3:85:BA:3D",
		"port": 51248,
		"pin": "171-94-744",
		"advertiser": "bonjour-hap"
	},
	"accessories": [],
	"platforms": [
		{
			"name": "Config",
			"port": 8582,
			"platform": "config",
			"log": {
				"method": "file",
				"path": "/data/data/com.termux/files/home/.homebridge/homebridge.log"
			}
		}
	]
}' > ~/.homebridge/config.json

echo '== Adding homebridge commands =='
echo 'exec node --experimental-modules $(which homebridge) "$@" 2>&1 | tee ~/.homebridge/homebridge.log' > ~/../usr/bin/hb
chmod +x ~/../usr/bin/hb

echo -e '== Installation successful ==\nExecute hb command to start'
