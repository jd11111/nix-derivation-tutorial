unset PATH
for p in $inputDrvs; do
  export PATH=$p/bin${PATH:+:}$PATH
done
