import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.UnsupportedAudioFileException;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import java.io.IOException;

int playerSize;
int playerX;
int playerY;
int accelleration;
int fallSpeed;
int maxFalling;
int powSpeed;
int score;
int scoreCounter;
int powSpeedX;
int powSpeedY;
int speedCounter;
int powerCounter;

boolean splashScreen;
boolean gameScreen;
boolean endScreen;

PImage splash;
PImage main;
PImage end;

player Block;
fallingBlocks[] FallBlock;
powerups Power;

AudioInputStream[] inputStream = new AudioInputStream[12];
Clip[] clips = new Clip[12];

void setup()
{
  size(600, 600);
  setupScreens();
  Block = new player();
  accelleration = 10;
  fallSpeed = 5;
  maxFalling = 5;
  powSpeed = 5;
  powSpeedX = 10;
  speedCounter = 0;
  
  splashScreen = true;
  gameScreen = false;
  endScreen = false;
  
  score = 0;
  scoreCounter = 0;
  
  setupAudio();
  
  FallBlock = new fallingBlocks[maxFalling];
  for (int i = 0; i < maxFalling; i++)
  {
    FallBlock[i] = new fallingBlocks(i);
  }
  
  Power = new powerups();
}

void setupAudio()
{
  for(int i = 1; i <= 12; i++)
  {
    try
    {
      inputStream[i-1] = AudioSystem.getAudioInputStream(new File("F:/Code Sources/Processing/Game_App/GameApp/Data", i + ".wav"));
      clips[i-1] = AudioSystem.getClip();
      clips[i-1].open(inputStream[i-1]);
    }
    catch(UnsupportedAudioFileException ex)
    {
      ex.printStackTrace(); 
    }
    catch(LineUnavailableException ex)
    {
      ex.printStackTrace();
    }
    catch(IOException ex)
    {
       ex.printStackTrace(); 
    }
  } 
}

void draw()
{
  if(splashScreen == true && gameScreen == false && endScreen == false)
  {
    drawSplash();
  }
  else if(splashScreen == false && gameScreen == true && endScreen == false)
  {
    drawGame();
  }
  else if(splashScreen == false && gameScreen == false && endScreen == true)
  {
    drawEnd();
  }
}

void drawSplash()
{
  image(splash, 0, 0);
    
  if (keyPressed && key == ENTER)
  {
    splashScreen = false;
    gameScreen = true;
  }
}

void drawGame()
{
  image(main, 0, 0);
  Block.draw();
  
  for (int i = 0; i < maxFalling; i++)
  {
    FallBlock[i].draw();
  }

  Power.draw();
  
  drawScore();
  calculateSpeed();
  checkDeath();
}

void drawEnd()
{
  image(end, 0, 0);
  
  fill(122, 13, 185);
  textSize(30);
  text(score, 290, 390);
  
  if (keyPressed && key == ENTER)
  {  
    accelleration = 10;
    fallSpeed = 5;
    maxFalling = 5;
    powSpeed = 5;
    powSpeedX = 10;
    speedCounter = 0; 
    Block.playerLives = 5;
    score = 0;
    scoreCounter = 0;
  
    endScreen = false;
    gameScreen = true;  
    
    for (int i = 0; i < maxFalling; i++)
      {
        FallBlock[i].fallY = 0-(50*(int)random(0,10));
        FallBlock[i].fallX = 50*(int)random(0, 12);
      }
  }
}

void checkDeath()
{
  if (Block.playerLives <= 0)
  {
    fallSpeed = 0;
    powSpeed = 0;
    
    gameScreen = false;
    endScreen = true;
  }
}
void drawScore()
{
  calculateScore();
  fill(255);
  textSize(15);
  text("Score : " + score, 20, 580);
  text("Lives : " + Block.playerLives, 530, 580);
  text("Speed : " + fallSpeed, 280, 580);
}

void calculateScore()
{ 
  if(scoreCounter >= 30)
  {
    scoreCounter = 0; 
    score += 1;
  }
  
  scoreCounter++;
}

void calculateSpeed()
{
  if(speedCounter >= 240)
  {
    speedCounter = 0;
    fallSpeed += 1;
  }
  
  speedCounter++;
}

void setupScreens()
{ 
  splash = loadImage("splash.png");
  main = loadImage("main.png");
  end = loadImage("end.png");
}

class powerups
{
  int type;
  int powX;
  int powY;
  int powSize = 30;
  
  powerups()
  {
    powX = (int)random(0,width-powSize);
    powY = (int)random(-1000, -500);
  }
  
  void update()
  { 
    //powY += powSpeed;
    if(powX + (powSize/2) > width || powX + (powSize/2) < 0)
    {
      powSpeedX = -1 * powSpeedX;
    }
    powX = powX + powSpeedX;
    powY = powY + powSpeed;
    
    if(powY + (powSize/2) > height)
    {
      powX = (int)random(0,width-powSize);
      powY = (int)random(-1000, -500);
    }
  }
  
  void draw()
  {
    fill(255);
    stroke(0);
    
    update();
    detection();
    
    drawPow(powX, powY);
    println("spawned powerup");
  }
  
  void drawPow(int powXpos, int powYpos)
  {
    fill(255);
    stroke(0);
    
    ellipse(powXpos, powYpos, powSize, powSize);
  }
  
  void detection()
  {
    if((Block.playerX >= powX && Block.playerX < powX+powSize && 
       Block.playerY >= powY && Block.playerY < powY+powSize) ||
       (powX >= Block.playerX && powX < Block.playerX+Block.playerSize &&
       powY >= Block.playerY && powY < Block.playerY+Block.playerSize))
       {
         println("Detect Power Up");   
         choosePower();
         
         powX = (int)random(0,width-powSize);
         powY = (int)random(-1000, -500);
       }
  }
  
  void choosePower()
  {
    type = (int)random(1,5);
    
    if(type == 1)
    {
      for (int i = 0; i < maxFalling; i++)
      {
        FallBlock[i].fallY = 0-(50*(int)random(10,50));
      }
    }
    else if(type == 2)
    {
      if (fallSpeed >= 10)
      {
        fallSpeed -= 5;
      }
    }
    else if(type == 3)
    {
      score += 10;
    }
    else if(type == 4)
    {
      Block.playerLives += 1;
    }
  }
}

class fallingBlocks
{
  int fallX;
  int fallY;
  int fallSize = 50;
  int i;

  fallingBlocks(int i)
  {
    this.i = i;
    fallX = 50*(int)random(0, 12);
    fallY = -i * fallSize;
    
  }

  void update()
  {
    fallY += fallSpeed;

    if (fallY >= height)
    {
      int j = fallX / 50;
      
      fallY = -i * 50;
      fallX = 50*(int)random(0, 12);
      
      println(j);
      //clips[j].loop(1);

      j = 0;
    }
  }

  void draw()
  {
    fill(0, 0, 255);

    update();
    detection();
    drawFall(fallX, fallY);
  }

  void drawFall(int fallXpos, int fallYpos)
  {
    fill(0, 0, 255);
    rect(fallXpos, fallYpos, fallSize, fallSize);
  }
  
  void detection()
  {
    if((Block.playerX >= fallX && Block.playerX < fallX+fallSize && 
       Block.playerY >= fallY && Block.playerY < fallY+fallSize) ||
       (fallX >= Block.playerX && fallX < Block.playerX+Block.playerSize &&
       fallY >= Block.playerY && fallY < Block.playerY+Block.playerSize))
       {
         println("Detect");
         
         fallY = 0-(50*(int)random(0,10));
         fallX = 50*(int)random(0, 12);
         
         Block.playerLives -= 1;
       }
  }
}
 
class player
{
  int playerX;
  int playerY;
  int playerSize = 30;
  int playerLives = 5;
  
  player()
  {
    playerX = width/2;
    playerY = height-100;
  }
  
   void draw()
  {
    fill(255, 0, 0);
    stroke(200, 0, 0);

    update();
    drawBlock(playerX, playerY);
  }

  void drawBlock(int playerXpos, int playerYpos)
  {
    rect(playerXpos, playerYpos, playerSize, playerSize);
  }

  void update()
  {
    if (keyPressed && keyCode == LEFT)
    {
      playerX -= accelleration;
    }

    if (keyPressed && keyCode == RIGHT)
    {
      playerX += accelleration;
    }

    if (playerX < 0)
    {
      playerX += accelleration;
    }

    if (playerX > (width-playerSize))
    {
      playerX -= accelleration;
    }
  }
}

