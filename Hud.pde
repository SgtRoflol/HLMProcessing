class Hud{
    Hud() {
        
    }
    void render() {
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