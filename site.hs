--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           System.Process


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    a <- makePatternDependency "test/1/*"
    b <- makePatternDependency "test/2/*"
    c <- makePatternDependency "test/3/*"
    rulesExtraDependencies [a, b, c] $ create ["test/all.txt"] $ do
        route idRoute
        compile $ do
            t <- unsafeCompiler $ do
                _ <- rawSystem "cp" ["test/1/test.txt", "test/1.txt"]
                _ <- rawSystem "cp" ["test/2/test.txt", "test/2.txt"]
                _ <- rawSystem "cp" ["test/3/test.txt", "test/3.txt"]
                readProcess "cat" ["test/1.txt", "test/2.txt", "test/1.txt"] ""
            makeItem t

    match "less/**" $
        compile getResourceBody

    d <- makePatternDependency "less/**"
    rulesExtraDependencies [d] $ create ["css/style.css"] $ do
        route idRoute
        compile $ loadBody "less/style.less"
            >>= makeItem
            >>= withItemBody
              (unixFilter "lessc" ["--clean-css","-O2", "--include-path=less","-"])
