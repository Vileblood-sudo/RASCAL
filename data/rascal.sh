#!/bin/bash
#=====================================================================================================
#		Filename: Rascal Scanner
#
#		Author: Steven Thompson
#		Purpose: This tool is designed to easily use Nmap scans for Vulnerability Assessments
#
#		Creation Date: Apr/02/2020
#		Last Revised: Apr/11/2021
#======================================================================================================
                                                                  
# This variable sets the delay timer to 5 seconds before
# returning to main menu
DELAY=5

# The below command will create a Scans folder to store
# scans that have been completed by the user
sudo mkdir -m 007 ~/Scans

# This while loop first displays a simple welcome message formatted
# to include red text colour. The loop will then displays the main
# menu of the script followed by a prompt to input a numerical option.
# Selection is stored in the REPLY variable
while [[ "$REPLY" != 0 ]]; do
	clear
	echo -e "\e[31mWelcome to my Nmap Scanner Script! Please Use Responsibly!\e[0m"
	echo
	echo -e "\e[31m~/Scans has been created to store scan results.\e[0m"
	echo
	echo -e "\e[31mIf Nmap is not currently installed, please update system prior to install.\e[0m"
	
    cat <<-_SF_
	
    ____  ___   _____ _________    __ 
   / __ \/   | / ___// ____/   |  / / 
  / /_/ / /| | \__ \/ /   / /| | / /  
 / _, _/ ___ |___/ / /___/ ___ |/ /___
/_/ |_/_/  |_/____/\____/_/  |_/_____/
        2020-2021 Steven Thompson                          

	Please choose from the following options (1-5):
	
	MAINTENANCE:
	1. Update System
	2. Install Nmap on System

	SCANS:
	3. Host Discovery Scan
	4. Nmap Scan Menu

	5. Exit Script

_SF_

	read -p "Enter Selection[1-5]: "

# This if block will use the REPLY variable to determine
# which conditional to follow. If the user selection is
# 1-7, the script will move to the appropriate nested if
# statement
	if [[ "$REPLY" =~ ^[1-5]$ ]]; then

# If the user chooses the first option, the system will
# perform system updates automatically, then return to menu
		if [[ "$REPLY" == 1 ]]; then
			sudo apt-get update
			sudo apt-get upgrade -y
			sleep "$DELAY"
		fi

# The second option will install Nmap on the system
# Return to menu following install
		if [[ "$REPLY" == 2 ]]; then
			sudo apt-get install nmap -y
			sleep "$DELAY"
		fi

# The third option will prompt the user to input a subnet
# which is store in the variable rangeInput. The script will
# call the variable and conduct a scan for IPs on the subnet via Nmap
# Output of the scan is sent to ~/Scans as a text file. Following
# file output, the script will return to main menu
		if [[ "$REPLY" == 3 ]]; then
			echo
			read -p "Please enter subnet (ex. 192.168.208.0/24): " rangeInput
			sudo nmap -sP $rangeInput > ~/Scans/$(date +%Y-%m-%d_%H:%M)_HostDiscovery.txt
			echo
			echo "Scan result sent to /Scans/HostDiscovery.txt"
			sleep "$DELAY"
		fi

# The fourth option will prompt the user to input an IP they would
# like to scan, then stored in the userSelect1 variable. The script
# will then display a menu to choose the type of scan to perform.
# The user selection will be stored in the REPLY variable to use for
# further nested if statements
		if [[ "$REPLY" == 4 ]]; then
			read -p "Please enter the IP you would like to scan (ex. 192.168.0.0): " userSelect1
			while [[ "$REPLY" != 0 ]]; do
				echo
				clear
				echo "TARGET: " $userSelect1
				cat <<-_SF1_
				
				Please choose the type of scan you would like to perform.
				
				1. Identify Operating System
				2. TCP Syn and UDP Scan (Common Ports)
				3. TCP Syn and UDP Scan (All Ports)
				4. TCP Syn and UDP Scan (Specify Port(s))
				5. Vulnerability Scan* (Vulscan)
				6. Main Menu
				
				*This option will install git if not already installed
				
				_SF1_
				

				read -p "Enter Selection [1-6]: "

# If option 1 is chosen from the above menu, a scan will be perfomed
# to attempt to determine the OS used by the target machine. Results
# are sent to the ~/Scans directory. Following file output, the script
# will return to the nmap menu using the delay timer
				if [[ "$REPLY" =~ ^[1-6]$ ]]; then
					if [[ "$REPLY" == 1 ]]; then
						echo "Please Wait. This may take a while.."
						echo
						sudo nmap -O $userSelect1 > ~/Scans/$(date +%Y-%m-%d_%H:%M)_OS.txt
						echo "Result sent to ~/Scans/OS.txt"
						sleep "$DELAY"

					fi

# If option 2 is chosen, a TCP UDP scan will be performed against common
# ports used by systems. Results are sent to the ~/Scans directory. Following
# output, the script will return to the nmap menu
					if [[ "$REPLY" == 2 ]]; then
						echo "Please Wait. This may take a while.."
						echo
						sudo nmap -sS -sU -Pn $userSelect1 > ~/Scans/$(date +%Y-%m-%d_%H:%M)_Common_Ports.txt
						echo "Result sent to ~/Scans/Common_Ports.txt"
						sleep "$DELAY"
					fi

# If option 3 is chosen, a TCP UDP scan will be performed against all ports.
# The result output is sent to the ~/Scans directory. Following output, the
# script will return to the nmap menu
					if [[ "$REPLY" == 3 ]]; then
						echo "Please Wait. This may take a while.."
						echo
						sudo nmap -sS -sU -Pn -p 1-65535 $userSelect1 > ~/Scans/$(date +%Y-%m-%d_%H:%M)_All_Ports.txt
						echo "Result sent to ~/Scans/All_Ports.txt"
						sleep "$DELAY"
					fi

# If option 4 is chosen, a TCP UDP scan will be performed against user
# specified ports. The user will be prompted to enter a port, or range of
# ports and will be stored in the userPorts variable. The nmap scan will
# call upon the variable to specify what ports to scan. Results are sent to
# the ~/Scans directory. Following output, the script will return to the nmap menu
					if [[ "$REPLY" == 4 ]]; then
						read -p "Please enter the port(s) you would like to scan(ex. 1-100, 80,21): " userPorts
						echo
						echo "Please Wait. This may take a while.."
						echo
						sudo nmap -sS -sU -Pn -p$userPorts $userSelect1 > ~/Scans/$(date +%Y-%m-%d_%H:%M)_UserPicked_Ports.txt
						echo "Result sent to ~/Scans/UserPicked_Ports.txt"
						sleep "$DELAY"
					fi

# If option 5 is chosen, first the script will install Git if it hasn't already
# been isntalled. Following Git install, Vulscan will be installed by git cloning
# and nmap will update it's database following install. The output of each install
# is directed to null to provide a cleaner user interface
					if [[ "$REPLY" == 5 ]]; then
						echo "Vulscan will be added to Nmap database if not already added"
                        echo
                        sudo apt-get install git -y > /dev/null 2>&1
                        sudo git clone https://github.com/scipag/vulscan scipag_vulscan > /dev/null 2>&1
                        sudo ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan > /dev/null 2>&1
                        sudo nmap --script-updatedb > /dev/null 2>&1
                        echo "Commencing Vulnerability Scan. This may take a while.."
                        sudo nmap -sV --script=vulscan/vulscan.nse $userSelect1 > ~/Scans/$(date +%Y-%m-%d_%H:%M)_Vuln_Scan.txt
						echo
                        echo "Result sent to ~/Scans/Vuln_Scan"
                        sleep "$DELAY"
					fi
# If option 6 is chosen, the command issued will restart the script, moving
# the user back to the initial menu.
					if [[ "$REPLY" == 6 ]]; then
						./$(basename $0) && exit
					fi

# If an option is chosen beyond 1-6, the script will alert the user
# they have made an improper selection, and will revert to the previous
# menu following the sleep delay
				else
					echo "INVALID SELECTION. PLEASE TRY AGAIN."
					sleep "$DELAY"
				fi
				done
			fi
# Back to the previous IF block, if option 5 is chosen, the echo command
# will display a thank you message on screen before returning immediately
# to the command line
		if [[ "$REPLY" == 5 ]]; then
			echo "Thank you!"
			exit
		fi

# If the script user inputs an incorrect option on the main menu,
# the user will be told they made an invalid selection, then be
# returned to the main menu
	else
		echo "INVALID SELECTION. PLEASE TRY AGAIN."
		sleep "$DELAY"
	fi

done