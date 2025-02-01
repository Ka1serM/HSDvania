# HSDvania
Ein Projekt der Hochschule Düsseldorf im Wintersemester 24/25
A small game project realized with the Godot game Engine from the Hochschule Düsseldorf made in the winter semester 24/25
![image](https://github.com/user-attachments/assets/ed8590a7-cbb0-416d-8f37-ffa9944d1c6d)


# The Plot
When an unassuming Student dozed off instead of paying attention during the lecture, they are trapped in a nightmare version of the school, complete with mad professors, dangerous cables and monitors to break.  
The source of the protagonist' blight is their pending Bafög application, which is indeed a bureaucratic nightmare. Only if all Entries are collected can the applycation be sent and the spell keeping the procastinating student in this realm be lifted. But beware: go gameover and one has to do it all over again... 


# Key Components
The game attempts to capture the essence of the 'Metroidvania' genre, in which players start off with nothing and by exploring gain new abilities. Said abilities add new ways to navigate, thus giving them even more options to explore and so on and so forth.  

### The Main Character

![image](https://github.com/user-attachments/assets/34317389-24c8-4cee-9b59-48b06778f827)  
In order to collect any Powerups, one first needs to have a collector. The unnamed Student, sporting a HSD-themed red hoodie, combines the more slower movementment speed of most Castlevania games with jump mechanics used by modern Platformers like Celeste to great succsess: The main parameters of How high the jump can get, how fast the character rises and falls can all be tweaked and coulped with a few other common tricks help give the movement a nice, snappy feel overall.  

 ![image](https://github.com/user-attachments/assets/44021c43-b988-4a2d-9c04-55048a23c819)



### The powerups  

![image](https://github.com/user-attachments/assets/3ae4e8da-d75c-4144-9aee-99b00cc1998e)
There are two powerups themed around diffrent aspects of IT; The Dualcore boots allow a double jump and the HTTP-request for a horizontal platform to spawn. Under the hood, the pickups work as Tiles from the same tileset that houses the level geometry and cable hazards and make use of Godots ability to attach custom data to any given tiles. Once collceted, they are erased from the map and a signal is sent out, allowing the Main Character to use the coresponding ability.  

![image](https://github.com/user-attachments/assets/514836b5-d03f-4568-b111-44bc30a6205e)

