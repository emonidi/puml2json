{
    var block = {
        components: [],
        databases: [],
        notes: [],
        interfaces: [],
        uses: []
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
  / declaration:databasedeclaration { block.databases.push(declaration);}
  / declaration:notedeclaration { block.notes.push(declaration);}
  / declaration:interfacedeclaration { block.interfaces.push(declaration);}
  / declaration:usesdeclaration { block.uses.push(declaration);}
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
componentdeclaration
  = _ "component " _ name:objectname _ archetype:archetypename? {return {name, type: archetype || "service"};}
databasedeclaration
  = _ "database " _ name:objectname _ archetype:archetypename? {return {name, type: archetype || "database"};}
notedeclaration
  = _ "note " _ noteposition _ name:objectname startblock newline props:notelines endblock {return {name, props};}
interfacedeclaration
  = _ "() " _ name:objectname _ "-" _ component:componentref _ {return {name, component};}
usesdeclaration
  = component:componentref _ ".>" _ iface:objectname _ {return {component, interface: iface};}
noteposition
  = "left of"
  / "right of"
  / "bottom of"
  / "top of"
id
  = id:([A-Za-z_][A-Za-z0-9.]*) {return [id[0], id[1].join("")].join("")}
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
