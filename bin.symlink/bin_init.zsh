# Add the folder containing this script to PATH
# Fancy folder detection found at http://stackoverflow.com/a/1820039/278810
export PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P):$PATH

# Set up fasd <https://github.com/clvv/fasd>
eval "$(fasd --init auto)"

# Set up resty <https://github.com/micha/resty>
. resty
