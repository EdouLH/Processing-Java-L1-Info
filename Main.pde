//////////////////////////////////////////////////
// Tuto                                         //
//////////////////////////////////////////////////

/*
Vous contrôlez une Voiture. Le but du jeu et d'esquiver les obstacles qui apparaissent au fur et à mesure sur la route
Petit à petit la difficultée évolue
Touches de contrôles de la voiture :
Z,Q,S,D
Touche pour recommencer :
Entrer
*/





//////////////////////////////////////////////////
// Code                                         //
//////////////////////////////////////////////////

// Déclaration des variables globales
float carX;
float carY; 
float carSpeed = 6;
float carWidth = 40;
float carHeight = 80;
boolean isUpPressed, isDownPressed, isLeftPressed, isRightPressed;
float[] obstacleX = new float[10];
float[] obstacleY = new float[10];
int[][] obstacleColors = new int[10][3];
boolean[] obstacleActif = new boolean[10];
float obstacleSpeed = 6;
int frameCount = 0;
int score = 0;
boolean isGameOver = false;
float roadLineY = -50;




// Initialisation de la fenêtre, du Jeu et des FPS
void setup() {
  size(400, 600);
  frameRate(60);
  resetGame();
}




// Execution du Jeu (Boucle Principale)
void draw() {
  background(100);
  
  // Augmente la Difficultée toutes les 240 frames
  if (score % 240 == 0) {
    obstacleSpeed += 0.2;
    carSpeed += 0.1;
  }

  
  // Execute les différentes fonctions
  if (!isGameOver) {
    drawRoad();
    moveCar();
    moveObstacles();
    spawnObstacle();
    checkCollision();
    score++;
  }
  
  drawCar();
  drawObstacles();
  displayScore();
  
  if (isGameOver) {
    displayGameOver();
  }
}




// Dessine la route et les lignes
void drawRoad() {
  fill(50);
  rect(0, 0, width, height);

  // Dessine les lignes blanches de la route
  fill(255);
  for (float y = roadLineY; y < height; y += 50) {
    rect(width / 2 - 5, y, 10, 30);
  }
  roadLineY += 4;

  // Remet les lignes au dessus
  if (roadLineY >= 50) {
    roadLineY = -50; 
  }
}




// Déplace la voiture
void moveCar() {
  // Les 4 prochaines conditions permettent à la voiture de ne pas aller trop vite lorsque l'on se déplace en diagonale
  if (isUpPressed && isLeftPressed) { 
    carY -= carSpeed / 1.5;
    carX -= carSpeed / 1.5;
  }
  else if (isUpPressed && isRightPressed) { 
    carY -= carSpeed / 1.5;
    carX += carSpeed / 1.5;
  }
  else if (isDownPressed && isLeftPressed) { 
    carY += carSpeed / 1.5;
    carX -= carSpeed / 1.5;
  }
  else if (isDownPressed && isRightPressed) { 
    carY += carSpeed / 1.5;
    carX += carSpeed / 1.5;
  }
  
  
  else {
    if (isUpPressed) carY -= carSpeed;
    if (isDownPressed) carY += carSpeed;
    if (isLeftPressed) carX -= carSpeed;
    if (isRightPressed) carX += carSpeed;
  }

  // Limite la position de la voiture aux bords de l'écran
  carX = constrain(carX, 0, width - carWidth);
  carY = constrain(carY, 0, height - carHeight);
}




// Génère un obstacle toutes les 45 frames
void spawnObstacle() {
  // Incrementation
  if (++frameCount >= 45) {
    for (int i = 0; i < obstacleX.length; i++) {
      // Si l'obstacle n'est pas déjà présent
      if (!obstacleActif[i]) {
        obstacleX[i] = random(width - 50);
        obstacleY[i] = -50;
        obstacleColors[i][0] = int(random(255));
        obstacleColors[i][1] = int(random(255));
        obstacleColors[i][2] = int(random(255));
        obstacleActif[i] = true;
        break;
      }
    }
    frameCount = 0;
  }
}




// Déplace les obstacles
void moveObstacles() {
  for (int i = 0; i < obstacleX.length; i++) {
    if (obstacleActif[i]) {
      obstacleY[i] += obstacleSpeed;
      if (obstacleY[i] > height) obstacleActif[i] = false;
    }
  }
}




// Vérifie les collisions
void checkCollision() {
  for (int i = 0; i < obstacleX.length; i++) {
    // On délimite la surface prise de chaque obstacle
    if (obstacleActif[i] && carX < obstacleX[i] + 50 && carX + carWidth > obstacleX[i] && carY < obstacleY[i] + 50 && (carY + carHeight) > obstacleY[i]) {
      isGameOver = true;
      break;
    }
  }
}




void drawCar() {
  // Voiture
  fill(62, 223, 89);
  rect(carX, carY, carWidth, carHeight, 10);

  // Vitres avant et arrière
  fill(50); 
  arc(carX + carWidth / 2, carY + 15, carWidth - 20, 30, PI, TWO_PI);
  arc(carX + carWidth / 2, carY + carHeight - 15, carWidth - 20, 30, 0, PI); 

  // Toit de la voiture
  fill(168, 255, 255);
  rect(carX + 10, carY + carHeight / 4, carWidth - 20, carHeight / 2, 5);
}





// Affiche les obstacles
void drawObstacles() {
  for (int i = 0; i < obstacleX.length; i++) {
    if (obstacleActif[i]) {
      fill(obstacleColors[i][0], obstacleColors[i][1], obstacleColors[i][2]);
      rect(obstacleX[i], obstacleY[i], 50, 50);
    }
  }
}




// Affiche le score
void displayScore() {
  fill(255);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Score: " + score, 10, 10);
  textAlign(RIGHT, TOP);
  // Décale la virgule à droite d'un, arrondi et redécale la virgule à gauche
  text("Difficultée : " + round(obstacleSpeed * 10) / 10.0, 400, 10);
}




// Affiche le message de fin de jeu
void displayGameOver() {
  fill(220, 49, 66);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Perdu", width / 2, height / 2);
  textSize(24);
  text("Score final : " + score, width / 2, height / 2 + 50);
  textSize(18);
  text("Appuyez sur 'Entrée' pour recommencer", width / 2, height / 2 + 100);
}




// Contrôles de la voiture (Quand une touche est pressé
void keyPressed() {
  if (key == 'z' || key == 'Z') isUpPressed = true;
  if (key == 's' || key == 'S') isDownPressed = true;
  if (key == 'q' || key == 'Q') isLeftPressed = true;
  if (key == 'd' || key == 'D') isRightPressed = true;

  // Relance le jeu lorsque la touche Entrée est pressée
  if (key == ENTER && isGameOver) {
    resetGame();  // Reset les variables du jeu
  }
}




// Quand une touche est relaché
void keyReleased() {
  if (key == 'z' || key == 'Z') isUpPressed = false;
  if (key == 's' || key == 'S') isDownPressed = false;
  if (key == 'q' || key == 'Q') isLeftPressed = false;
  if (key == 'd' || key == 'D') isRightPressed = false;
}




// Réinitialise les variables
void resetGame() {
  carX = width / 2 - carWidth / 2;
  carY = height - carHeight - 20;
  score = 0;
  carSpeed = 6;
  obstacleSpeed = 6;
  isGameOver = false;
  for (int i = 0; i < obstacleX.length; i++) {
    obstacleActif[i] = false;
  }
  frameCount = 0;
}
