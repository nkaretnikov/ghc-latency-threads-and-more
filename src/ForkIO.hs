{-# OPTIONS -fno-warn-deprecations #-}
module Main where

import Network.Socket
import Control.Concurrent
import Data.Time
import Control.Monad
import Debug.Trace

wasteTime :: IO ()
wasteTime = forever yield

startServer :: IO ()-- {{{
startServer = do
    sock <- socket AF_INET Stream 0
    setSocketOption sock ReuseAddr 1
    bind sock (SockAddrInet 4242 iNADDR_ANY)
    listen sock 2
    mainLoop sock-- }}}

mainLoop :: Socket -> IO ()-- {{{
mainLoop sock = do
    conn <- accept sock
    traceMarkerIO "----------- got incomming connection"
    _ <- forkIO $ runConn conn
    traceMarkerIO "----------- going back to the main loop"
    mainLoop sock
    -- }}}
 
runConn :: (Socket, SockAddr) -> IO ()-- {{{
runConn (sock, _) = do
    "." <- recv sock 1
    traceMarkerIO "server: got client message"
    _ <- send sock "."
    traceMarkerIO "server: replied to client"
    close sock-- }}}

showUS :: NominalDiffTime -> Int-- {{{
showUS x = round ((1000 :: Double) * 1000 * realToFrac x)-- }}}

runClient :: IO ()-- {{{
runClient = do
    traceMarkerIO "Client: getting server address"
    serverAddr <- head <$> getAddrInfo Nothing (Just "127.0.0.1") (Just "4242")
    sock <- socket (addrFamily serverAddr) Stream defaultProtocol
    traceMarkerIO "Client: connecting to server"
    connect sock (addrAddress serverAddr)
    traceMarkerIO "Client: sending message"
    msgSender sock
    close sock-- }}}

msgSender :: Socket -> IO ()-- {{{
msgSender sock = do
    before <- getCurrentTime
    _ <- send sock "."
    "." <- recv sock 1
    traceMarkerIO "Client: got reply"
    after <- getCurrentTime
    print $ showUS $ after `diffUTCTime` before-- }}}


main :: IO ()
main = do
    threadDelay 1000000

    replicateM_ 10000 $ forkIO wasteTime
    _ <- forkIO startServer
    replicateM_ 10 $ runClient
