#This bash script clones all the repositories from a given github username into a folder which will be named $USERNAME
#Dependencies:
#	sudo apt install gh

USERNAME=sifr01

gh repo list $USERNAME --limit 1000  | while read -r repo _; do \
	gh repo clone "$repo" "$repo"
done
