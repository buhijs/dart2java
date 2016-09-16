// Copyright 2016, the Dart project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;

import org.junit.Test;
import scenario.__TopLevel;

public class Tests {
  @Test
  public void testNullEquals() {
    assertTrue(__TopLevel.nullEqualsNull1());
    assertTrue(__TopLevel.nullEqualsNull2());
    assertTrue(__TopLevel.nullEqualsNull3());
    assertTrue(__TopLevel.nullEqualsNull4());
    assertTrue(__TopLevel.nullEqualsNull5());
  }

  @Test
  public void testNullToString() {
    assertEquals("null", __TopLevel.nullToString1());
    assertEquals("null", __TopLevel.nullToString2());
    assertEquals("null", __TopLevel.nullToString3());
  }
}
