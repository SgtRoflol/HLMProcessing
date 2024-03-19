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
    boolean isHostile;
    
    Weapon(String Name, int maxAmmo, int projSpeed, int cad,float reloadTime, PVector Origin, boolean isHostile, Wall[] Walls,int damage) {
        this.isHostile = isHostile;
        this.Origin = Origin;
        this.Name = Name;
        this.maxAmmo = maxAmmo;
        this.ammo = maxAmmo;
        this.projSpeed = projSpeed;
        //Array mit Projektilen mit der selben Größe wie das Magazin
        Bullets = new Projectile[ammo];
        
        //Alle Projektile instanziieren
        for (int i = 0; i < Bullets.length; i++) {
            Bullets[i] = new Projectile(projSpeed,isHostile,new PVector(Origin.x,Origin.y),Walls,damage);
        }
        this.cad = cad;
        this.reloadTime = reloadTime;  
    }
    
    //Zielen
    void setTarget(float targY,float targX) {
        this.targX = targY;
        this.targY = targX;
    }
    
    void render() {    
        //Alle Projektile rendern  
        for (Projectile Bullet : Bullets) {
            Bullet.Origin = new PVector(Origin.x,Origin.y);
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
    
    void shoot() {
        //Wenn die Waffe schießt und keine Munition mehr hat und feindlich ist -> Nachladen
        if (isShooting && ammo <= 0 && isHostile) {
            cooldown = reloadTime;
            ammo = maxAmmo;
            return;
        }
        //Wenn die Waffe schießt und der Cooldown 0 ist und noch Munition übrig ist
        if (isShooting && cooldown == 0 && ammo != 0) {
            if (!isHostile && ammo != 0) {
                //Kamera schütteln und SChussgeräusch senden wenn Spieler schießt
                worldCamera.screenshake(5);
                osc.send(shotMessage,meineAdresse);
            }
            if (isHostile) {
                //Schussgeräusch senden wenn Gegner schießt
                osc.send(enemyShotMessage,meineAdresse);
            }
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
    
    void reload() {
        //Munition zurücksetzen und Nachladecooldown setzen
        if (key == 'r') {                
            osc.send(reloadMessage,meineAdresse);
            cooldown = reloadTime;
            ammo = maxAmmo;
        }
    }
    
    //Kugeln zurückgeben
    Projectile[] getBullets() {
        return Bullets;
    }
    
    //Wände setzen
    void setWalls(Wall[] Walls) {
        for (Projectile Bullet : Bullets) {
            Bullet.setWalls(Walls);
        }
    }
}
