set -ex
set -o pipefail

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $(dirname $0)/../vendor/library.sh

echo $DIR

#source "$DIR/../vendor/library.sh"

echo "good!"