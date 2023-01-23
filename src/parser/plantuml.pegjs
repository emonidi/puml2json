{
    var block = []
    
    function parseParticipant(type,desc) {

    	const split = desc.join("").replace(/\"/ig,"").split(" as ");
        if(split[1]){
          block.push({
              type:"participant",
              participantType:type,
              name:split[1].trim(),
              alias:split[0].trim()
          });
        }else{
        	 block.push({
              type:"participant",
              participantType:type,
              name:desc.join("")
          });
        }
    } 
}
plantumlfile
	= (_ newline)* _ "@startuml" _ newline umllines _ "@enduml" (_ newline)* {return block;}
_
  = [ \t]*
  / [ \n]*
  / [ \t\r\n]*

newline
  = "\r\n"
  / "\n"
  / "\r"

color
  = [#][0-9a-fA-F]+

string
  = [A-Za-z_,."():<>#0-9=;! ]*

event
  = p1:[A-Za-z_,."() ]* arrow:arrow p2:[A-Za-z_,."() ]* [:] msg:message newline {
  		function getLineType(arrow){
        	switch (arrow){
            	case "->":
                case "<-":
                	return "normal"
                case "-->":
                case "<--":
                	return "dotted"
            }
        }
		block.push({
        	type:"event",
        	p1:p1.join("").trim(),
            p2:p2.join("").trim(),
            lineType: getLineType(arrow),
            message:msg.join("").trim()
        })
    }

participant
	= type:"participant" desc:string {
    	parseParticipant(type,desc)
    }
    / type:"actor" desc:string {
    	parseParticipant(type,desc)
    }

note
  = "note " position:"over " participant:[A-Za-z_,."() ]* [:] message:string {
  		console.log(position);
        block.push(
        	{
              type:"note",
              position,
              participant:participant.join(""),
              message:message.join("")
            }
        )
  } 
  / "/ note " position:"over " participant:[A-Za-z_,."() ]* [:] message:string {
  		
        block.push(
        	{
              type:"note",
              sameLevel:true,
              position,
              participant:participant.join(""),
              message:message.join("")
            }
        )
  } 
  / "note " position:"left" [:] message:string {
  	  block.push(
        	{
              type:"note",
              position,
              message:message.join("")
            }
        )
  }
  / "note " position:"right" [:] message:string {
  	  block.push(
        	{
              type:"note",
              position,
              message:message.join("")
            }
        )
  }
  / "note " direction:string newline* {
  	throw new Error("multiline notes are not supported.")
  }

activate
	= "activate " participant:string { block.push({type:"activate",participant:participant.join("")}) }

autonumber
	= "autonumber" {block.push({atuonumber:true, type:"autonumber"})}

message
  = string

arrow
  = "->"
  / "-->"
  / "<--"
  / "<-"

alt
	= "alt " message:string {
    	block.push({else:true,message:message.join(""), type:"alt"})
    }
    
end_group
	= "end group"{
    	block.push({endgroup:true, type:"end_group"})
    }
    

else
	= "else " message:string {
    	block.push({else:true,message:message.join(""), type:"else"})
    }
box
 = "box " name:string newline{
 	let n = name.join("");
    let split = n.split("#");
    if(split.length > 1){
    	block.push({
        	type:"box",
            name:split[0],
            color:"#"+split[1]
        })
    }else{
    	 block.push({
         	type:"box",
            name:name.join("")
         })
    }
 }
end_box 
 = "end box" {
 	block.push({type:"end_box",end_box:true})
 }

comment
 = "=="  com:string _ {
 	block.push(
    	{
    		comment:com.join("").replace("==").trim(),
    		type:"comment"
        }
    )
 } 

umllines
  = lines:umlline*
  
umlline
   = autonumber newline
  / _ lines:event
  / _ newline
  / _ participant newline
  / _ activate newline
  / _ note newline
  / _ alt newline
  / _ else newline
  / _ end_group newline
  / _ box 
  / _ end_box newline
  / _ comment
