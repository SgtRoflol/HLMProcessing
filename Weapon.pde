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
    
    void render() {    
        //Alle Projektile rendern  
        for (int i = 0; i < Bullets.length; i++) {
            Bullets[i].render();
        } 
        //Wenn der Cooldown ziwschen Schüssen/nach dem Nachladen noch nicht 0 ist -> runterzählen
        if (cooldown > 1.0f) {
            cooldown--;
        }
        //Wenn der Cooldown kleiner 1 oder negativ ist -> cooldown = 0 -> um ggf Fehler zu vermeiden    
        else{
            cooldown = 0;
        }
        println(cooldown);
    }
    
    void shoot() {
        //Wenn Maus gedrückt wird und cooldown 0 ist, also geschossen werden soll UND darf
        if (isShooting && cooldown == 0) {
            
            //Überprüfen, ob aktuell noch ein Projektil nicht geschossen wurde und Munition übrig ist
            for (int i = 0; i < Bullets.length; i++) {
                if (!Bullets[i].isActive && ammo != 0) {
                    //Ungeschossenes Projektil schiessen, Munition verringern und cooldown setzen
                    Bullets[i].spawn();
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
            cooldown = reloadTime;
            ammo = maxAmmo;
        }
    }
    
}
