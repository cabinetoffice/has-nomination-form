/*****************************************************************
 *  Class: bg_communityUtils
 *  
 *  Author:  Simon Lewis - BrightGen Ltd
 *  Created: 06/04/2016
 *  Changes:
 *
 ****************************************************************/
public class bg_communityUtils{

    public static final String USER_TYPE_GUEST = 'Guest';
    
    /*
    Method: isCommunityUserLoggedIn
    */
    public static Boolean IsCommunityUserLoggedIn()
    {
        if(UserInfo.getUserType() != USER_TYPE_GUEST)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}