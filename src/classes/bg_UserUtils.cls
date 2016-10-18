/********************************************************************
 * bg_UserUtils 
 *
 * Utilities class for User Object
 * 
 * Test Class: bg_UserUtils_Test
 *
 * Author: Chris Eales - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 *
 ********************************************************************/
public class bg_UserUtils 
{
    public static User getUserById(Id userId)
    {
        User result;
        result = [SELECT    Id, Name, ContactId, Contact.AccountId, ProfileId, CommunityNickName, UserName, Email
                  FROM      User
                  WHERE     Id = :userId];
        return result;
    }
    
    public static User getUserByUsernameEmailNickname(String username, String email, String nickname)
    {
        User result;
        try
        {
            result = [SELECT    Id, Name, ContactId, Contact.AccountId, ProfileId, Username, Email, CommunityNickname
                      FROM      User
                      WHERE     Username = :username
                      AND       Email = :email
                      AND       CommunityNickname = :nickname];
        }
        catch (Exception ex)
        {
            //do not bubble the exception just return null
            result = null;
        }
        return result;              
    }
}