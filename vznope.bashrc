export VZN_ROOT=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
export PATH=$VZN_ROOT/bin:$PATH
export VZN=$VZN_ROOT/bin/vzn
alias vzn="sudo $VZN"

