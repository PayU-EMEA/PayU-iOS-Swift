//
//  SoftAcceptComponents.swift
//  
//  Created by PayU S.A. on 05/12/2022.
//  Copyright © 2022 PayU S.A. All rights reserved.
//

import Foundation

struct SoftAcceptComponents {
  func iframe(redirectUri: String) -> String {
    return String(
      format: """
            <div class='modal'>
             <div class='modal-content'>
              <iframe sandbox='allow-forms allow-scripts allow-same-origin' src=%@>
              </iframe>
             </div>
            </div>
            """,
      redirectUri)
  }

  func javascript(origin: String, channelName: String) -> String {
    return String(
      format: """
            javascript:(
             function() {
              window.addEventListener ('message', handleMessage, false);
              function handleMessage(msg) {
               if (msg.origin === %@) {
                var result = {data: msg.data, href: window.location.href, userAgent: navigator.userAgent};
                window.webkit.messageHandlers.%@.postMessage(JSON.stringify(result));
               }
              }
             }
            )();
            """,
      origin, channelName)
  }
}
