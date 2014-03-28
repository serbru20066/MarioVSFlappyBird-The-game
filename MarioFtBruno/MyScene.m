//
//  MyScene.m
//  MarioFtBruno
//
//  Created by Tecla Labs - Mac Mini 4 on 27/03/14.
//  Copyright (c) 2014 Tecla Labs - Mac Mini 4. All rights reserved.
//

#import "MyScene.h"
#define ARC4RANDOM_MAX 0x100000000
@implementation MyScene


-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        //variables
        speed=2;
        lifes=3;
        isDamaged=NO;

        
        background=[SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        background.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.size=CGSizeMake(380, 290);
        
        
        SKSpriteNode *mario=[SKSpriteNode spriteNodeWithImageNamed:@"mario_normal.png"];
        mario.position=CGPointMake(50,220);
        mario.size=CGSizeMake(25, 25);
        mario.zPosition=100;
        mario.name=@"mario";
        
        
        //labels
      
        [self performSelector:@selector(createLabel) withObject:nil afterDelay:0.1];
    
        
        
        SKLabelNode *labelObjectivo  =[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelObjectivo.position=CGPointMake(300,340);
        labelObjectivo.text= @"END";
        labelObjectivo.fontSize=15;
        labelObjectivo.zPosition=104;
        [self addChild:labelObjectivo];

        
        //Botones
        
        SKSpriteNode *rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"button2.png"];
        rightButton.position = CGPointMake(300,280);
        rightButton.size=CGSizeMake(40, 40);
        rightButton.name = @"rightButoon";
        rightButton.zPosition = 101;
        
        SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"button1.png"];
        leftButton.position = CGPointMake(20,280);
        leftButton.size=CGSizeMake(40, 40);
        leftButton.name = @"leftButoon";
        leftButton.zPosition = 102;
        
        SKSpriteNode *jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"button3.png"];
        jumpButton.position = CGPointMake(300,320);
        jumpButton.size=CGSizeMake(40, 40);
        jumpButton.name = @"jumpButton";
        jumpButton.zPosition = 103;
        
        [self addChild:rightButton];
        [self addChild:leftButton];
        [self addChild:jumpButton];
       

        [self performSelector:@selector(createBirds) withObject:nil afterDelay:2.0];
        [self addChild:background];
        [self addChild:mario];
        [self performSelector:@selector(animateBird) withObject:nil afterDelay:0.1];
    
    }
    return self;
}
-(void) createLabel{
    [lifeLabel removeFromParent];
    lifeLabel  =[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lifeLabel.text=@" ";
    lifeLabel.position=CGPointMake(50,320);
    lifeLabel.text= [NSString stringWithFormat:@"%@ + %d",@"Lifes :",lifes];
    lifeLabel.fontSize=15;
    lifeLabel.zPosition=104;
    [self addChild:lifeLabel];
    
    
    [self performSelector:@selector(createLabel) withObject:nil afterDelay:0.1];
 
}
-(void) createBirds{
    
    self.flappyBird=[SKSpriteNode spriteNodeWithImageNamed:@"Yellow_Bird_Wing_Down.png"];
    float maxRange=260;
    float minRange=220;
    
    float randomPosY = ((float)arc4random() / ARC4RANDOM_MAX * (maxRange - minRange)) + minRange;
    self.flappyBird.position=CGPointMake(300,randomPosY);
    self.flappyBird.size=CGSizeMake(25, 25);
    self.flappyBird.name=@"bird";
    self.flappyBird.zPosition=80;
    [self addChild:self.flappyBird];
    
    float randomNum= arc4random_uniform(3) +3;
    [self performSelector:@selector(createBirds) withObject:nil afterDelay:randomNum];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    SKTextureAtlas *atlasMario=[SKTextureAtlas atlasNamed:@"mario_camina"]; //dont need .atlas
    
    SKTexture *marioText1=[atlasMario textureNamed:@"mario_camina1.png"];
    SKTexture *marioText2=[atlasMario textureNamed:@"mario_camina2.png"];
    
    NSArray *atlasTexture =@[marioText1,marioText2];
    SKAction* resetTexture =[SKAction setTexture:[SKTexture textureWithImageNamed:@"mario_normal.png"]];
    SKAction* marioAnimation =[SKAction animateWithTextures:atlasTexture timePerFrame:0.1];
    
    marioMovement=[SKAction sequence:@[marioAnimation,resetTexture]];
    
    
    //Acciones de los botones
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    SKSpriteNode* nodo =(SKSpriteNode*)[self childNodeWithName:@"mario"];
    if (nodo.position.x<0 )
    {
        nodo.position=CGPointMake(node.position.x-20,220);
 
    }
    if (nodo.position.y<0 ) {
        
        nodo.position=CGPointMake(node.position.x,node.position.y+20);
    }
    else if ([node.name isEqualToString:@"rightButoon"]) {
        
        
        nodo.position=CGPointMake(nodo.position.x +4, nodo.position.y);
        [nodo runAction:marioMovement];
    }
    else if ([node.name isEqualToString:@"leftButoon"]) {
        
        nodo.position=CGPointMake(nodo.position.x -4, nodo.position.y);
        [nodo runAction:marioMovement];
    }
    else if ([node.name isEqualToString:@"jumpButton"]) {
        
        [self JumpingMario];
    }
    else
    {
        
        [self JumpingMario];
    
    }

}

-(void) JumpingMario
{
    SKAction* resetTexture =[SKAction setTexture:[SKTexture textureWithImageNamed:@"mario_normal.png"]];
    SKSpriteNode* nodo =(SKSpriteNode*)[self childNodeWithName:@"mario"];
    SKAction* jumpText =[SKAction setTexture:[SKTexture textureWithImageNamed:@"mario_salta.png"]];
    SKAction* wait =[SKAction waitForDuration:0.5];
    jumpAnimation =[SKAction sequence:@[jumpText,wait,resetTexture]];
    [nodo runAction:jumpAnimation];
    
    SKAction* moveUp =[SKAction moveByX:0 y:35 duration:0.3];
    SKAction* moveUp2 =[SKAction moveByX:0 y:25 duration:0.3];
    SKAction* moveDown =[SKAction moveByX:0 y:-60 duration:0.3];
    
    jumpMovement=[SKAction sequence:@[moveUp,moveUp2,moveDown]];
    [nodo runAction:jumpMovement];
    

}
-(void)animateBird{
    [self initializeBird];
    [self performSelector:@selector(animateBird) withObject:nil afterDelay:0.3];

}

-(void)update:(CFTimeInterval)currentTime {
    
    SKSpriteNode* mario=(SKSpriteNode*)[self childNodeWithName:@"mario"];

    [self enumerateChildNodesWithName:@"bird" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.x<0 )
        {
            [node removeFromParent];
        }
        else
        {
            node.position=CGPointMake(node.position.x -speed, node.position.y);
        }
        
        if ([mario intersectsNode:node] && isDamaged==NO)
        {
            [self doDamage:mario];
        }
        
    }
     ];

}

-(void)doDamage:(SKSpriteNode*)marioSprite{
    isDamaged=YES;
    lifes-=1;
    
    SKAction* push=[SKAction moveByX:-50 y:0 duration:0.2];
    [marioSprite runAction:push];
    SKAction *pulseRed =[SKAction sequence:@[
                                             
                                             [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.4],
                                             [SKAction colorizeWithColorBlendFactor:0.0 duration:0.3],
                                             [SKAction performSelector:@selector(damageDone) onTarget:self]
                                             
                                             ]];
    [marioSprite runAction:pulseRed];
    
}

-(void) damageDone {
    
    isDamaged=NO;
    
    if(lifes==0) {
        
        [self gameOver];
    }
    
}
-(void)gameOver{
    
    SKScene *nextScene =[[MyScene alloc] initWithSize:self.size];
    SKTransition *doors=[SKTransition fadeWithColor:[SKColor redColor] duration:2];
    
    [self.view presentScene:nextScene transition:doors];
}

- (void)initializeBird
{
    SKTextureAtlas *atlasBird=[SKTextureAtlas atlasNamed:@"bird"]; //dont need .atlas
    
    SKTexture *birdText1=[atlasBird textureNamed:@"Yellow_Bird_Wing_Down.png"];
    SKTexture *birdText2=[atlasBird textureNamed:@"Yellow_Bird_Wing_Straight.png"];
    SKTexture *birdText3=[atlasBird textureNamed:@"Yellow_Bird_Wing_Up.png"];

    NSArray *atlasTexture =@[birdText1,birdText2,birdText3];
    SKAction* resetTexture =[SKAction setTexture:[SKTexture textureWithImageNamed:@"Yellow_Bird_Wing_Down.png"]];
    SKAction* atlasBirdAnimation =[SKAction animateWithTextures:atlasTexture timePerFrame:0.1];
    
    jumpMovement=[SKAction sequence:@[atlasBirdAnimation,resetTexture]];
                                        
    SKSpriteNode* nodo =(SKSpriteNode*)[self childNodeWithName:@"bird"];
    [nodo runAction:jumpMovement];
    

}


@end
