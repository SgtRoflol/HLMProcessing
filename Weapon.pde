class Weapon{
    String Name;
    int ammo;
    int maxAmmo;
    Projectile[] Bullets;
    boolean isShooting = false;
    int projSpeed;
    float cad;
    float cooldown = 0;
    
    Weapon(String Name, int maxAmmo, int projSpeed, int cad) {
        this.Name = Name;
        this.maxAmmo = maxAmmo;
        this.ammo = maxAmmo;
        this.projSpeed = projSpeed;
        Bullets = new Projectile[ammo];
        for (int i = 0; i < Bullets.length; i++) {
            Bullets[i] = new Projectile(projSpeed);
        }
        this.cad = cad;
        
        
    }
    
    void render() {        for (int i = 0; i < Bullets.length; i++) {
            Bullets[i].render();
        } 
        
        if (cooldown > 1.0f) {
            cooldown--;
        }  
        
        else{
            cooldown = 0;
        }
        println(cooldown);
    }
    
    void shoot() {
        if (isShooting && cooldown == 0) {
            for (int i = 0; i < Bullets.length; i++) {
                if (!Bullets[i].isActive && ammo != 0) {
                    Bullets[i].spawn();
                    ammo--;
                    cooldown = cad;
                    break;
                }
            }
        }
        
    }
    
    void reload() {
        if (key == 'r') {
            ammo = maxAmmo;
        }
    }
    
}
