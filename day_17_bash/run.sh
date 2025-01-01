#!/bin/bash
ct=$(cat in.txt) && ct_s="${ct//$'\n'/'|'}" && regs=() && instr=()
for tok in $(echo "${ct_s%%||*}" | grep -Po "[0-9]+"); do regs+=("$tok"); done
for tok in $(echo "${ct_s#*||*}" | grep -Po "[0-9]"); do instr+=("$tok"); done
len=${#instr[@]}
prog () {
  out=() && idx=0
  while [[ idx -lt len ]]; do
    o="c" && op="${instr[$idx]}" && arg="${instr[(($idx + 1))]}"
    case $arg in
      0|1|2|3) combo=arg ;;
      4|5|6) combo="${regs[$(( arg - 4 ))]}" ;;
    esac
    case $op in
      0|6|7) (( regs[$(( op % 5 ))] = regs[0] / (1 << combo) )) ;;
      1) (( regs[1] = regs[1] ^ arg )) ;;
      2) (( regs[1] = combo & 7 )) ;;
      3) if [[ ${regs[0]} != 0 ]]; then o=arg; fi ;;
      4) (( regs[1] = regs[1] ^ regs[2] )) ;;
      5) out+=($((combo & 7))) ;;
    esac
    case "$o" in
      c) (( idx += 2 )) ;;
      *) (( idx = o * 2 )) ;;
    esac
  done
}
prog && t="${out[*]}" && regs[shift=final=0]=1
while [[ ${#out[@]} -lt len ]]; do (( regs[0] = 1 << (shift += 3) )) && prog; done
(( i = len ))
while [[ $(( i -= 1 )) -ge $((curr = 0)) ]]; do
  (( inc = 1 << shift ))
  while [[ "${out[*]:i:len}" != "${instr[*]:i:len}" ]]; do regs=($(( final + (curr += inc) )) 0 0) && prog; done
  (( shift -= 3 )) && (( final += curr ))
done
printf "%s\n%s\n" "${t//$' '/','}" "$final"