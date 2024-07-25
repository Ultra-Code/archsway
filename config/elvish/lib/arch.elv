use platform

fn is-termux {
     # (eq (uname -m) aarch64)
     if (and (eq $platform:os "android") (eq $platform:arch "arm64") (has-env PREFIX)) {
          put  $true
     } else {
          put $false
     }
}
edit:add-var is-termux~ $is-termux~

fn is-wsl {
     if (and (eq $platform:os "linux") (eq $platform:arch "amd64") (has-env WSLENV)) { 
          put $true
     } else {
          put $false
     }
}
