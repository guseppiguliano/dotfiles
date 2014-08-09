# \u4e20\u4e21\u4e22\u4e23 = 丠両丢丣
unescapeUnicode = (str) ->
  str.replace /\\u([\da-f]{4})/gi, (str, p1) ->
    String.fromCharCode(parseInt(p1, 16))

# \\[bfnrtv0/"]
unescapeLiterals = (str) ->
  str = str.replace /\\u([\da-f]{4})/gi, (str, p1) ->
    String.fromCharCode parseInt(p1, 16)
  str.replace(/\\n/g,'\n').replace(/\\"/g,'"').replace(new RegExp('\\\\/','g'),'/')

# 2056776401.50 = 2,056,776,401.50
humanizeNumber = (n) ->
  n = n.toString()
  while true
    n2 = n.replace /(\d)(\d{3})($|,|\.)/g, '$1,$2$3'
    if n == n2 then break else n = n2
  n
