//
//  MyScene.h
//  MarioFtBruno
//

//  Copyright (c) 2014 Tecla Labs - Mac Mini 4. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene
{
    int speed;
    SKAction *jumpAnimation;
    SKAction *jumpMovement;
    SKAction *marioMovement;
    int lifes;
    bool isDamaged;
    SKLabelNode *lifeLabel;
    SKSpriteNode *background;
}
@property (nonatomic) SKSpriteNode* flappyBird;
@property (nonatomic) NSArray* flappyBirdFrames;
@end
