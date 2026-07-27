## Bash

- globs: method of string matching
  - * -> 0+ characters
  - ? -> exactly 1 character
  - [abc] -> a or b or c

- redirection
  - > -> redirects stdout
  - 2> -> redirects stderr
  - 2>&1 -> redirects stderr to stdout
    - cmd > output.txt 2>&1 -> runs cmd, sending both stdout and stderr to output.txt

- `read -r varnam` reads stdin into a variable
  - the `-r` means to not allow backslash escapes
  - can give multiple variable names, which and contents will be separated by $IFS
  - setting IFS to the the empty string will allow for looping over lines of text, or not stripping whitespace for `read`

- parameter expansion
  - `${variable:-$defaultvariable}` -> uses $defaultvariable if $variable is unset or null
  - `${variable:?errormessage}` -> prints "errormessage" and exists if $variable is unset or null
  - `${#variable}` -> length of the string/array $variable
  - `${variable#prefix}`/`${variable%suffix}` -> remove the prefix/suffix from $variable
  - `${variable/find/replace}`/`${variable//findall/replaceall}`
  - `${variable:offset:length}` -> get a substring of $variable

- running cleanup: `trap`
  - `trap [command to run] [event to trap]`
  - trappable evants include 
    - unix signals: INT (sent with Ctrl+C), TERM (?), etc
    - script exiting: EXIT
    - every line of code: DEBUG
    - function returns: RETURN
    - others!
  - if you've defined some function `cleanup` to run at the end of the script: `trap cleanup EXIT`

- setting things to error
  - `set -e` -> stop script on error
  - `set -u` -> stop on unset variable
  - `set -o pipefail` -> stop if one component of a pipe errors

- debugging
  - `set -x` -> print each line as it runs with variables expanded
  - `trap read DEBUG` -> since `DEBUG` is trigged before each line, `read` will be trigged before each line, making the script stop on each line

