{ config }:
path:
config.lib.dag.entryAfter [ "writeBoundary" ] ''
  		if [[ ! -f "${path}" ]]; then 
  			touch "${path}"
  		fi
  	''

# home.activation.pulseConfig =
#   let
#     createEmpty = import ../scripts/create_empty.nix {inherit config;} ;
#   in
#   createEmpty "${config.common.configHome}/pulse/cookie";
#
