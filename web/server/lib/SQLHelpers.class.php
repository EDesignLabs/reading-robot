<?php
//Static class for future sql helper methods
class SQLHelpers
{
    private static $initialized = false;

    private static function initialize()
    {
        if (self::$initialized)
                return;
        self::$initialized = true;
    }

    public static function SQL()
    {
        self::initialize();
    }
}

?>