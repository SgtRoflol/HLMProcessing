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
        text(Play.hp,30,100);
        if (CurScene.enemyAmount <= 0) {
            textSize(50);
            textAlign(CENTER);
            text("YIPPIE!",width / 2,height / 2);
            textAlign(CORNER);
        }
    }
}
