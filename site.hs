--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "less/*.less" $
        compile getResourceBody

    d <- makePatternDependency "less/**"
    rulesExtraDependencies [d] $ create ["css/style.css"] $ do
        route idRoute
        compile $ loadBody "less/style.less"
            >>= makeItem
            >>= withItemBody
              (unixFilter "lessc" ["--clean-css","-O2", "--include-path=less","-"])
