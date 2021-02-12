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
  = (noise newline)* noise "@startuml" noise newline umllines noise "@enduml" (noise newline)* {return block;}
startblock
  = noise "{" noise
endblock
  = noise "}"
noise
  = [ \t]*
splitter
  = ":"
newline
  = "\r\n"
  / "\n"
color
  = [#][0-9a-fA-F]+
umllines
  = lines:(umlline*)
notelines
  = lines:(noteline*) {return lines.filter(line => line).reduce((map, prop) => {map[prop[0]] = prop[1]; return map;}, {});}
umlline
  = titleset newline
  / headerset newline
  / noise newline
  / commentline
  / declaration:componentdeclaration newline { block.components.push(declaration);}
  / declaration:databasedeclaration newline { block.databases.push(declaration);}
  / declaration:notedeclaration newline { block.notes.push(declaration);}
  / declaration:interfacedeclaration newline { block.interfaces.push(declaration);}
  / declaration:usesdeclaration newline { block.uses.push(declaration);}
noteline
  = noise property:propertyname ":"  noise value:propertyvalue noise newline {return [property, value];}
  / commentline {return null;}
  / noise newline {return null;}
titleset
  = noise "title " noise [^\r\n]+ noise
headerset
  = noise "header" noise [^\r\n]+ noise
commentline
  = noise "'" [^\r\n]*
componentdeclaration
  = noise "component " noise componentname:objectname noise "<<" archetype:componentarchetype ">>" noise {return {name: componentname, type: archetype};}
databasedeclaration
  = noise "database " noise databasename:objectname noise "<<" archetype:databasearchetype ">>" noise {return {name: databasename, type: archetype};}
notedeclaration
  = noise "note " noise noteposition noise name:objectname startblock newline lines:notelines endblock {return {name: name, props: lines};}
interfacedeclaration
  = noise "()" noise interfacename:objectname noise "-" noise component:componentref noise {return {name: interfacename, component: component};}
usesdeclaration
  = component:componentref noise ".>" noise interfacename:objectname noise {return {component: component, interface: interfacename};}
noteposition
  = "left of"
  / "right of"
  / "bottom of"
  / "top of"
id
  = id:([A-Za-z_][A-Za-z0-9.]*) {return [id[0], id[1].join("")].join("")}
objectname
  = id
  / "\"" objectname:[^\"]* "\"" {return objectname.join(""); }
componentref
  = id
  / [\[] name:[^\]]* [\]] {return name.join("");}
componentarchetype
  = archetype:"service" {return archetype;}
databasearchetype
  = archetype:"SQL" {return archetype;}
propertyname
  = id
propertyvalue
  = value:[a-zA-Z0-9.-]* {return value.join("");}
