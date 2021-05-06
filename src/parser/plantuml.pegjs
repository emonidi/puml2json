{
    var block = {
        components: [],
        notes: [],
        links: []
    }
}
plantumlfile
  = (_ newline)* _ "@startuml" _ newline umllines _ "@enduml" (_ newline)* {return block;}
_
  = [ \t]*
startblock
  = _ "{" _
endblock
  = _ "}"
splitter
  = ":"
newline
  = "\r\n"
  / "\n"
color
  = [#][0-9a-fA-F]+
umllines
  = lines:umlline*
notelines
  = lines:noteline* {return lines.filter(line => line).reduce((map, prop) => {map[prop[0]] = prop[1]; return map;}, {});}
umlline
  = titleset newline
  / headerset newline
  / _ newline
  / comment newline
  / declaration newline
declaration
  = declaration:componentdeclaration { block.components.push(declaration);}
  / declaration:databasedeclaration { block.components.push(declaration);}
  / declaration:notedeclaration { block.notes.push(declaration);}
  / declaration:linkdeclaration { block.links.push(declaration);}
noteline
  = _ property:propertyname ":"  _ value:propertyvalue _ newline {return [property, value];}
  / comment newline {return null;}
  / _ newline {return null;}
titleset
  = _ "title " _ [^\r\n]+ _
headerset
  = _ "header " _ [^\r\n]+ _
comment
  = _ "'" [^\r\n]*
text
  = content:[^\r\n]* {return content.join("");}
componentdeclaration
  = _ "component " _ name:objectname _ archetype:archetypename? {return {name, type: archetype || "service"};}
databasedeclaration
  = _ "database " _ name:objectname _ archetype:archetypename? {return {name, type: archetype || "database"};}
notedeclaration
  = _ "note " _ noteposition _ ref:objectname startblock newline props:notelines endblock {return {ref, props};}
linkdeclaration
  = source:componentref _ linktype _ target:componentref _ ":" _ type:text {return {source, target, type};}
noteposition
  = "left of"
  / "right of"
  / "bottom of"
  / "top of"
linktype
  = ".>"
  / "..>"
  / "->"
  / "-->"
id
  = id:([A-Za-z_][A-Za-z0-9\-]*) {return [id[0], id[1].join("")].join("")}
objectname
  = id
  / "\"" name:[^\"]* "\"" {return name.join(""); }
componentref
  = id
  / [\[] name:[^\]]* [\]] {return name.join("");}
archetypename
  = "<<" name:id ">>" {return name;}
propertyname
  = id
propertyvalue
  = value:[a-zA-Z0-9.-]* {return value.join("");}
