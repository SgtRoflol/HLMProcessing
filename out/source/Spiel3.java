/* autogenerated by Processing revision 1293 on 2024-01-29 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Spiel3 extends PApplet {

Camera worldCamera; //Kamera
Player Play; //Spieler
Weapon curWeapon; //Aktuelle Waffe
Scene CurScene;
Hud Overlay;
Projectile[] PlayerProj; //Alle Spielerprojektile


public void setup() {
    /* size commented out by preprocessor */;
    //Framerate und Anti-Aliasing setzen
    /* smooth commented out by preprocessor */;
    frameRate(60);
    CurScene = new Scene();
    worldCamera = new Camera(); // Worldcamera wird genutzt, um Level größer als der Screen erstellen zu können
    Play = new Player(CurScene.getWalls()); //Spieler instanziieren
    curWeapon = Play.Waffen[0]; // Aktuelle Waffe
    PlayerProj = new Projectile[0];
    for (Weapon Waffe : Play.Waffen) {
        PlayerProj = (Projectile[])concat(PlayerProj, Waffe.getBullets());
    }
    Overlay = new Hud();
    CurScene.setPlayer(Play);
    
}

public void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.Pos.x, -worldCamera.Pos.y); //Worldcam verschiebt Achsen um Bewegungswert
    worldCamera.draw();
    Play.renderWeapons();
    curWeapon.shoot();
    CurScene.render();
    //WorldCamera Ende
    popMatrix();
    Overlay.render(); 
    fill(255);
    //Spieler zur Maus drehen
    Play.move();   
}

public void mousePressed() {
    curWeapon.isShooting = true; //Wird gesetzt um beständiges Schießen bei Halten der Maustaste zu ermöglichen
}

public void mouseReleased() {
    curWeapon.isShooting = false;
}

public void keyPressed() {
    //Zwischen Waffen wechseln
    Play.switchWeapons();
    
    //Es kann nur nachgeladen werden, wenn geschossen wird, ausserdem kann einige Zeit nicht geschossen
    //werden, um dauerladen und Schießen zu vermeiden
    if (!curWeapon.isShooting) {
        curWeapon.reload();
    }
}

class Camera {
    int shiftdist;
    PVector Pos;
    
    
    Camera() {
        Pos = new PVector(0, 0);
        shiftdist = 20;
    }
    
    public void draw() {
        if (keyPressed) {
            if (key == 'w') {if (!Play.getCollision(new PVector(Pos.x,Pos.y - 5))) {Pos.y -= 5;} } 
            if (key == 's') {if (!Play.getCollision(new PVector(Pos.x,Pos.y + 5))) {Pos.y += 5;} } 
            if (key == 'a') {if (!Play.getCollision(new PVector(Pos.x - 5,Pos.y))) {Pos.x -= 5;} } 
            if (key == 'd') {if (!Play.getCollision(new PVector(Pos.x + 5,Pos.y))) {Pos.x += 5;} } 
            
        }
    }
    
}
class Enemy{
    boolean isAlive;
    PVector Pos;
    Projectile[] PlayerProj;
    int size;
    Wall[] Waende;
    Player Play;
    
    Enemy(PVector Pos) {
        this.Pos = Pos;
        isAlive = true;
        size = 50;
        this.Play = Play;
    }
    
    public void getWalls(Wall[] Walls) {
        this.Waende = Walls;
    }
    
    public void setPlayer(Player Play) {
        this.Play = Play;
    } 
    
    public void render() {
        checkHit();
        if (isAlive) {
            fill(0,0,255);
            ellipse(Pos.x,Pos.y,size,size);
            if (isOnScreen() && !canSee()) {
                line(Pos.x,Pos.y,width / 2 + worldCamera.Pos.x,height / 2 + worldCamera.Pos.y);
            }
        }
    }
    
    public boolean isOnScreen() {
        if (Pos.x > worldCamera.Pos.x + width + size || Pos.x + size < worldCamera.Pos.x) {
            return false;
        }   
        if (Pos.y > worldCamera.Pos.y + height + size || Pos.y + size < worldCamera.Pos.y) {
            return false;
        }
        
        return true;
    }
    
    public void setProjectiles(Projectile[] Bullets) {
        PlayerProj = Bullets;
    }
    
    public void checkHit() {
        for (Projectile Bullet : PlayerProj) {
            float disX = Pos.x - Bullet.Pos.x;
            float disY = Pos.y - Bullet.Pos.y;
            if (sqrt(sq(disX) + sq(disY)) < size / 2 && Bullet.isActive && isAlive) {
                isAlive = false;
                Bullet.init();
            }
        }
    }
    
    public boolean canSee() {
        for (Wall Wand : Waende) {
            if (lineRect(width / 2 + worldCamera.Pos.x,height / 2 + worldCamera.Pos.y,Pos.x,Pos.y,Wand.Pos.x,Wand.Pos.y,Wand.w,Wand.h)) {
                return true;
            }
        }
        return false;
    }
    
    // LINE/RECTANGLE
    public boolean lineRect(float x1, float y1, float x2, float y2, float rx, float ry, float rw, float rh) {
        
        // check if the line has hit any of the rectangle's sides
        // uses the Line/Line function below
        boolean left =   lineLine(x1,y1,x2,y2, rx,ry,rx, ry + rh);
        boolean right =  lineLine(x1,y1,x2,y2, rx + rw,ry, rx + rw,ry + rh);
        boolean top =    lineLine(x1,y1,x2,y2, rx,ry, rx + rw,ry);
        boolean bottom = lineLine(x1,y1,x2,y2, rx,ry + rh, rx + rw,ry + rh);
        
        // if ANY of the above are true, the line
        //has hitthe rectangle
        if (left || right || top || bottom) {
            println("HUHU");
            return true;
            
        }
        println("Huch");
        return false;
        
    }
    
    
    // LINE / LINE
    public boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
        
        // calculate the direction of the lines
        float uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        float uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        
        // if uA and uB are between 0 - 1, lines are colliding
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
            
            return true;
        }
        return false;
    }
}
class Hud{
    Hud() {
        
    }
    public void render() {
        fill(0);
        //Zeigt Waffenname und Munition
        textSize(35);
        text(curWeapon.ammo,30,40);
        //Falls Waffe aktuell Cooldown hat (gerade geschossen wurde / nachgeladen wird) -> Name rot
        if (curWeapon.cooldown != 0) {
            fill(255,0,0);
        }
        text(curWeapon.Name,30,70);
    }
}
class Player{
    float angle;
    float x;
    float y;
    int farbe;
    int weapInd = 0;
    int size;
    Wall closestWall;
    PVector Origin;
    Wall[] Waende;
    Weapon[] Waffen; //Array mit allen Waffen
    
    Player(Wall[] Waende) {
        //Position auf Bildschirmmitte legen und Farbe festlegen
        x = width / 2;
        y = height / 2;
        Origin = new PVector(worldCamera.Pos.x + height / 2,worldCamera.Pos.y + height / 2);    
        farbe = color(255,0,0);
        size = 50;
        this.Waende = Waende;
        
        Waffen = new Weapon[3]; //Arraylänge definieren
        Waffen[0] = new Weapon("Waffe",30,10,5,50,Origin,false,CurScene.getWalls());// Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
        Waffen[1] = new Weapon("Waffe2",10,20,30,60,Origin,false,CurScene.getWalls());
        Waffen[2] = new Weapon("Waffe3",5,40,70,100,Origin,false,CurScene.getWalls()); 
    }
    
    
    public void render() {
        //Spieler zeichnen, aktuelle fill Farbe speichern und später zurücksetzen
        int curcol = g.fillColor;
        fill(farbe);
        rectMode(CENTER);
        rect(0,0,size,size);
        fill(curcol);
        println(getCollision(worldCamera.Pos));
        for (Weapon Waffe : Waffen) {
            Waffe.Origin = new PVector(worldCamera.Pos.x + height / 2,worldCamera.Pos.y + height / 2);
        }
        
    }
    
    public void renderWeapons() {
        for (Weapon Waffe : Waffen) {
            Waffe.render();
            Waffe.setTarget(worldCamera.Pos.x + mouseX,worldCamera.Pos.y + mouseY);
            
        }
    }
    
    public void move() {
        //Spielerrechteck zur Maus hindrehen
        pushMatrix();
        angle = atan2(x - mouseX, y - mouseY);
        translate(x, y);
        rotate( -angle - HALF_PI);
        render();
        popMatrix();
    }
    
    
    public void switchWeapons() {
        // Akutelle Waffe wird auf Waffe aus Array an allen Waffen gesetzt, somit können diese gewechselt werden
        if (key == 'e') {
            if (weapInd == Waffen.length - 1) {
                curWeapon.isShooting = false;
                weapInd = 0;
                curWeapon = Waffen[weapInd];
            }
            else{
                curWeapon.isShooting = false;
                curWeapon = Waffen[weapInd + 1];
                weapInd++;
            }
        }
        if (key == 'q') {
            if (weapInd == 0) {
                curWeapon.isShooting = false;
                weapInd = Waffen.length - 1;
                curWeapon = Waffen[weapInd];  
            }
            else{
                curWeapon.isShooting = false;
                curWeapon = Waffen[weapInd - 1];
                weapInd--;
            }
        }
        
    }
    
    public boolean getCollision(PVector Pos) {
        
        for (Wall Wand : Waende) {
            for (Wall Wall : Waende) {
                if (x + Pos.x + size / 2 >= Wall.Pos.x && x + Pos.x - size / 2 <= Wall.Pos.x + Wall.w && 
                    y + Pos.y + size / 2 >= Wall.Pos.y && y + Pos.y - size / 2 <= Wall.Pos.y + Wall.h) {
                    closestWall = Wand;
                    return true;
                } 
            }
        }
        return false;
    }
}
class Projectile{
    boolean isActive;
    PVector Pos;
    float speed;
    PVector dir;
    Wall[] Walls;
    boolean isHostile;
    PVector Origin;
    
    Projectile(float speed, boolean hostile, PVector Origin, Wall[] Walls) {
        this.speed = speed;
        isHostile = hostile;
        this.Origin = Origin;
        this.Walls = Walls;
        Pos = new PVector();
        dir = new PVector();
        init();
    }
    
    
    public void init() {
        isActive = false;
        Pos = Origin;
    }
    
    public void spawn(float x, float y) {
        init();
        PVector Target = new PVector(x,y);
        dir = PVector.sub(Target,Pos);
        dir.normalize();
        dir.mult(speed);
        isActive = true;
    }
    
    public void render() {
        ellipseMode(CENTER);
        int curcol = g.fillColor;
        fill(255, 255, 0);
        
        if (checkCollision()) {
            isActive = false;
        }
        else{
            if (isActive) {
                Pos = Pos.add(dir);
                ellipse(Pos.x,Pos.y,10,10);   
            } 
            //Farbe wird auf vorherigen Wert zurückgesett
            fill(curcol);
    } }
    
    public boolean checkCollision() {
        //Wenn das Projektil ausserhalb des Bildschirms ist
        if (Pos.x > worldCamera.Pos.x + width || Pos.x < worldCamera.Pos.x) {
            return true;
        }    
        if (Pos.y > worldCamera.Pos.y + height || Pos.y < worldCamera.Pos.y) {
            return true;
        }
        
        //Wenn das Projektil eine Wand trifft
        for (Wall Wall : Walls) {
            if (Pos.x + dir.x >= Wall.Pos.x && Pos.x + dir.x <= Wall.Pos.x + Wall.w && 
                Pos.y + dir.y >= Wall.Pos.y && Pos.y + dir.y <= Wall.Pos.y + Wall.h) {
                return true;
            } 
        }
        return false;
    }
    
}
class Scene{
    Wall[] Waende;
    Enemy[] Gegners;
    
    Scene() {
        Waende = new Wall[3];
        Waende[0] = new Wall(new PVector(700,200),300,100);
        Waende[1] = new Wall(new PVector(200,600),200,70);
        Waende[2] = new Wall(new PVector(10,100),300,100);
        
        Gegners = new Enemy[15];
        for (int i = 0; i < Gegners.length; i++) {
            Gegners[i] = new Enemy(new PVector(i * 60, 400));
            Gegners[i].getWalls(Waende);
        }
    }
    
    public void setPlayer(Player Play) {
        for (Enemy Gegner : Gegners) {
            Gegner.setPlayer(Play);
        }
    }
    
    public void render() {
        for (Wall Wand : Waende) {
            Wand.render();
        }
        
        for (Enemy Gegner : Gegners) {
            Gegner.setProjectiles(PlayerProj);
            Gegner.render();
        }
    }
    
    public Wall[] getWalls() {
        return this.Waende;
    }
}
class Wall{
    PVector Pos;
    int w;
    int h;
    
    Wall(PVector Pos, int w, int h) {
        this.Pos = Pos;
        this.w = w;
        this.h = h;
    }
    public void render() {
        fill(0,255,0);
        rectMode(CORNER);
        rect(Pos.x,Pos.y,w,h);
        fill(0);
        stroke(0);
        line(Pos.x,Pos.y,Pos.x + w,Pos.y + h);
        line(Pos.x,Pos.y + h,Pos.x + w,Pos.y);
        
    }
    
    
}
class Weapon{
    String Name; //Name
    int ammo; //Aktuelle Munition
    int maxAmmo; //Maximale Munition
    Projectile[] Bullets; //Array mit allen Waffeneigenen Projektilen
    boolean isShooting = false;
    int projSpeed; // Geschwindigkeit der gefeuerten Projektile
    float cad; //Feuerrate
    float cooldown = 0; //cooldown ziwschen Schüssen / nach Nachladen
    float reloadTime; //Zeit zum Nachladen
    float targX;
    float targY;
    PVector Origin;
    
    Weapon(String Name, int maxAmmo, int projSpeed, int cad,float reloadTime, PVector Origin, boolean isHostile, Wall[] Walls) {
        this.Origin = Origin;
        this.Name = Name;
        this.maxAmmo = maxAmmo;
        this.ammo = maxAmmo;
        this.projSpeed = projSpeed;
        //Array mit Projektilen mit der selben Größe wie das Magazin
        Bullets = new Projectile[ammo];
        //Alle Projektile instanziieren
        for (int i = 0; i < Bullets.length; i++) {
            Bullets[i] = new Projectile(projSpeed,isHostile,Origin,Walls);
        }
        this.cad = cad;
        this.reloadTime = reloadTime;  
    }
    
    public void setTarget(float targY,float targX) {
        this.targX = targY;
        this.targY = targX;
    }
    
    public void render() {    
        //Alle Projektile rendern  
        for (Projectile Bullet : Bullets) {
            Bullet.Origin = Origin;
            Bullet.render();
        } 
        //Wenn der Cooldown ziwschen Schüssen/nach dem Nachladen noch nicht 0 ist -> runterzählen
        if (cooldown > 1.0f) {
            cooldown--;
        }
        //Wenn der Cooldown kleiner 1 oder negativ ist -> cooldown = 0 -> um ggf Fehler zu vermeiden    
        else{
            cooldown = 0;
        }
    }
    
    public void shoot() {
        //Wenn Maus gedrückt wird und cooldown 0 ist, also geschossen werden soll UND darf
        if (isShooting && cooldown == 0 && ammo != 0) {
            //Überprüfen, ob aktuell noch ein Projektil nicht geschossen wurde und Munition übrig ist
            for (Projectile Bullet : Bullets) {
                if (!Bullet.isActive) {
                    //Ungeschossenes Projektil schiessen, Munition verringern und cooldown setzen
                    Bullet.spawn(targX,targY);
                    ammo--;
                    cooldown = cad;
                    break;
                }
                
            }
        }
        
    }
    
    public void reload() {
        //Munition zurücksetzen und Nachladecooldown setzen
        if (key == 'r') {
            cooldown = reloadTime;
            ammo = maxAmmo;
        }
    }
    
    
    public Projectile[] getBullets() {
        return Bullets;
    }
}


  public void settings() { size(800, 800, P2D);
smooth(4); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Spiel3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
