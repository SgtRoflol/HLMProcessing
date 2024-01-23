/* autogenerated by Processing revision 1293 on 2024-01-23 */
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
Weapon[] Waffen; //Array mit allen Waffen
Weapon curWeapon; //Aktuelle Waffe
int weapInd; //Index der aktuellen Waffe, wird benötigt um wechseln zu können
Wall[] Waende;
Hud Overlay;


public void setup() {
    Waende = new Wall[3];
    Waende[0] = new Wall(new PVector(700,200),300,100);
    Waende[1] = new Wall(new PVector(200,600),200,70);
    Waende[2] = new Wall(new PVector(10,100),300,100);
    weapInd = 0;
    //Framerate und Anti-Aliasing setzen
    frameRate(60);
    /* smooth commented out by preprocessor */;
    /* size commented out by preprocessor */;
    worldCamera = new Camera(); // Worldcamera wird genutzt, um Level größer als der Screen erstellen zu können
    Play = new Player(); //Spieler instanziieren
    Waffen = new Weapon[3]; //Arraylänge definieren
    Waffen[0] = new Weapon("Waffe",30,10,5,50);// Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
    Waffen[1] = new Weapon("Waffe2",10,20,30,60);
    Waffen[2] = new Weapon("Waffe3",5,40,70,100); 
    curWeapon = Waffen[0]; // Aktuelle Waffe
    Overlay = new Hud();
    for (Weapon Waffe : Waffen) {
        Waffe.getWalls(Waende);
    }
}

public void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.pos.x, -worldCamera.pos.y); //Worldcam verschiebt Achsen um Bewegungswert
    worldCamera.draw();
    //Alle Waffen/Alle AKTIVEN Projektile aller Waffen rendern
    for (Weapon Waffe : Waffen) {
        Waffe.render();
    }
    //Aktuelle Waffe abfeuern falls möglich
    curWeapon.shoot();
    for (Wall Wand : Waende) {
        Wand.render();
    }
    //WorldCamera Ende
    rect(25,25,25,25);
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
    switchWeapons();
    
    //Es kann nur nachgeladen werden, wenn geschossen wird, ausserdem kann einige Zeit nicht geschossen
    //werden, um dauerladen und Schießen zu vermeiden
    if (!curWeapon.isShooting) {
        curWeapon.reload();
    }
}

public void switchWeapons() {
    // Akutelle Waffe wird auf Waffe aus Array an allen Waffen gesetzt, somit können diese gewechselt werden
    if (key == 'e' && weapInd < Waffen.length - 1) {
        curWeapon.isShooting = false;
        curWeapon = Waffen[weapInd + 1];
        weapInd++;
    }
    if (key == 'q' && weapInd > 0) {
        curWeapon.isShooting = false;
        curWeapon = Waffen[weapInd - 1];
        weapInd--;
    }
    
}

class Camera {
    PVector pos;
    
    Camera() {
        pos = new PVector(0, 0);
    }
    
    public void draw() {
        if (keyPressed) {
            if (key == 'w') pos.y -= 5;
            if (key == 's') pos.y += 5;
            if (key == 'a') pos.x -= 5;
            if (key == 'd') pos.x += 5;
        }
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
    
    Player() {
        //Position auf Bildschirmmitte legen und Farbe festlegen
        x = width / 2;
        y = height / 2;
        farbe = color(255,0,0);
    }
    
    public void render() {
        //Spieler zeichnen, aktuelle fill Farbe speichern und später zurücksetzen
        int curcol = g.fillColor;
        fill(farbe);
        rectMode(CENTER);
        rect(0,0,50,50);
        fill(curcol);
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
    
}
class Projectile{
    boolean isActive;
    PVector Pos;
    float speed;
    PVector dir;
    Wall[] Walls;
    
    Projectile(float speed) {
        this.speed = speed;
        init();
    }
    
    public void init() {
        //Setzt Projektil zurück, setzt auf Spielerposition und setzt Zielposition auf 0
        isActive = false;
        Pos = new PVector(width / 2,height / 2);
        Pos.x = worldCamera.pos.x + width / 2;
        Pos.y = worldCamera.pos.y + height / 2;
        dir = new PVector(0,0);
    }
    
    public void spawn() {
        
        //Wird erst zurückgesetzt
        //Mausvektor
        //Zeilvektor wird berechnet -> Verbindungsvektor von Spielerpsition zu Mausposition
        init();
        PVector mouse = new PVector(worldCamera.pos.x + mouseX,worldCamera.pos.y + mouseY);
        dir = PVector.sub(mouse,Pos);
        
        //Vektor wird normalisiert -> Alle Komponenten werden durch den selben Wert dividiert
        //Vektorrichtung bleibt gleich aber länge wird 1
        //Richtungsvektor wird mit Geschwindigkeit multipliziert -> Vekor wird um Geschwindigkeitswert verlängert
        //Projektil wird auf aktiv gesetzt -> Nicht mehr an Spieler fixiert, sondern kann sich nun richtung Ziel Bewegen
        dir.normalize();
        dir.mult(speed);
        isActive = true;
    }
    
    public void render() {
        //Kreis wird mittig von Koordinaten aus gezeichnet
        //Aktuell in draw genutzte Farbe wird gespeichert und später auf diesen Wert zurückgesetzt
        //um Farbfehler zu vermeiden
        ellipseMode(CENTER);
        int curcol = g.fillColor;
        fill(255, 255, 0);
        
        if (isActive) {
            //Überprüfung, ob sich das Projektil ausserhalb des Bildschirms befindet
            //Projektil wird um Richtungsvektor verschoben
            //Projektil wird gezeichnet
            checkBounds();
            collision();
            Pos = Pos.add(dir);
            ellipse(Pos.x,Pos.y,10,10);   
        }
        //Wenn nicht aktiv, fixiert auf Spielerposition
        else{
            Pos.x = worldCamera.pos.x + width / 2;
            Pos.y = worldCamera.pos.y + height / 2;
        }   
        //Farbe wird auf vorherigen Wert zurückgesett
        fill(curcol);
    }
    
    public void checkBounds() {
        
        //Wenn sich das Projektil ausserhalb des Bildschirms befindet, wird es zurückgesetzt
        if (Pos.x > worldCamera.pos.x + width || Pos.x < worldCamera.pos.x) {
            init();
        }    
        if (Pos.y > worldCamera.pos.y + height || Pos.y < worldCamera.pos.y) {
            init();
        }
    }
    
    public void getWalls(Wall[] Walls) {
        this.Walls = Walls;
    }
    
    public void collision() {
        for (Wall Wall : Walls) {
            if (Pos.x >= Wall.Pos.x && Pos.x <= Wall.Pos.x + Wall.w && 
                Pos.y >= Wall.Pos.y && Pos.y <= Wall.Pos.y + Wall.h) {
                init();
            } 
        }
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
        rect(Pos.x,Pos.y,w,h);
        fill(0);
        stroke(0);
        line(Pos.x,Pos.y Pos.x + w,Pos.y + h);
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
    
    Weapon(String Name, int maxAmmo, int projSpeed, int cad,float reloadTime) {
        this.Name = Name;
        this.maxAmmo = maxAmmo;
        this.ammo = maxAmmo;
        this.projSpeed = projSpeed;
        //Array mit Projektilen mit der selben Größe wie das Magazin
        Bullets = new Projectile[ammo];
        //Alle Projektile instanziieren
        for (int i = 0; i < Bullets.length; i++) {
            Bullets[i] = new Projectile(projSpeed);
        }
        this.cad = cad;
        this.reloadTime = reloadTime;
        
        
    }
    
    public void render() {    
        //Alle Projektile rendern  
        for (Projectile Bullet : Bullets) {
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
        if (isShooting && cooldown == 0) {
            
            //Überprüfen, ob aktuell noch ein Projektil nicht geschossen wurde und Munition übrig ist
            for (Projectile Bullet : Bullets) {
                if (!Bullet.isActive && ammo != 0) {
                    //Ungeschossenes Projektil schiessen, Munition verringern und cooldown setzen
                    Bullet.spawn();
                    ammo--;
                    cooldown = cad;
                    break;
                }
            }
        }
        
    }
    
    public void getWalls(Wall[] Walls) {
        for (Projectile Bullet : Bullets) {
            Bullet.getWalls(Walls);
        }
    }
    
    public void reload() {
        //Munition zurücksetzen und Nachladecooldown setzen
        if (key == 'r') {
            cooldown = reloadTime;
            ammo = maxAmmo;
        }
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
