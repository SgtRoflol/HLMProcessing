class Hud{
    Hud() {
        
    }
    void render() {
        fill(255);
        //Zeigt Waffenname und Munition
        textSize(35);
        
        text(curWeapon.ammo,30,40);
        //Falls Waffe aktuell Cooldown hat (gerade geschossen wurde / nachgeladen wird) -> Name rot
        if (curWeapon.cooldown != 0) {
            fill(255,0,0);
        }
        else {
            fill(255);
        }
        //Zeigt HP und Anzahl der Gegner
        text(curWeapon.Name,30,70);
        text("HP: " + Play.hp,30,100);
        text("Gegner: " + CurScene.enemyAmount,30,130);
        
        //Falls keine Gegner mehr -> Text
        if (CurScene.enemyAmount <= 0) {
            textSize(50);
            textAlign(CENTER);
            text("GO BACK TO THE BEGINNING",width / 2,height / 2 - 30);
            textAlign(CORNER);
        }
        //Falls Spieler tot -> Text
        if (!Play.isAlive) {
            textSize(50);
            textAlign(CENTER);
            text("Press 'R' to respawn.",width / 2,height / 2 - 30);
            textAlign(CORNER);
        }
    }
}
