
eval <<-TESTME, binding, __FILE__, __LINE__+1

  raise "Fail line 4 !"
TESTME
